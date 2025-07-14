document.addEventListener('DOMContentLoaded', () => {

    function switchToTab(targetTab) {
        const editorTabs = document.querySelectorAll('.editor-tab');
        editorTabs.forEach(tab => {
            tab.classList.remove('active');
        });
        targetTab.classList.add('active');

        document.querySelectorAll('.editor-container').forEach(container => {
            container.classList.remove('active');
        });

        const containerId = `${targetTab.dataset.tab}-container`;
        const targetContainer = document.getElementById(containerId);
        if (targetContainer) {
            targetContainer.classList.add('active');
        }
    }

    function cleanUrl() {
        const url = new URL(window.location.href);
        if (url.searchParams.has('run')) {
            url.searchParams.delete('run');
            window.history.replaceState({}, document.title, url.toString());}
    }

    function checkUrlAndSetTab() {
        const urlParams = new URLSearchParams(window.location.search);
        const runParam = urlParams.get('run');

        if (runParam === 'true') {
            const resultsTab = document.querySelector('.editor-tab[data-tab="results"]');
            if (resultsTab) {
                switchToTab(resultsTab);
                cleanUrl();
            }
        }
    }

    // Asosiy kodni ishga tushurish
    function initializeEditor() {
        const editorElement = document.getElementById('code-editor');
        if (!editorElement) {
            console.error('Code editor element not found.');
            return;
        }

        // Initialize CodeMirror
        window.codeMirrorEditor = CodeMirror.fromTextArea(editorElement, {
            mode: 'text/x-java',
            theme: 'dracula',
            lineNumbers: false,
            indentUnit: 4,
            indentWithTabs: false,
            autoCloseBrackets: true,
            matchBrackets: true,
            extraKeys: {
                'Tab': (cm) => cm.execCommand('indentMore'),
                'Shift-Tab': (cm) => cm.execCommand('indentLess'),
                'Ctrl-Alt-L': (cm) => cm.execCommand('indentAuto')
            }
        });

        // Set editor size and z-index
        codeMirrorEditor.setSize('100%', '100%');
        editorElement.style.zIndex = '10';

        // Form submission: Update hidden input with CodeMirror content
        document.querySelectorAll("form").forEach(form => {
            form.addEventListener("submit", function (event) {
                const hiddenInput = form.querySelector("input[name='code']");
                if (hiddenInput) {
                    hiddenInput.value = codeMirrorEditor.getValue();}
            });
        });

        // Update line numbers
        function updateLineNumbers() {
            const lines = codeMirrorEditor.lineCount();
            const lineNumbers = document.getElementById('line-numbers');
            if (lineNumbers) {
                lineNumbers.innerHTML = Array.from({length: lines}, (_, i) => i + 1).join('\n');
                lineNumbers.style.height = `${codeMirrorEditor.getWrapperElement().offsetHeight}px`;
            }
        }

        // Sync line numbers with editor scroll
        codeMirrorEditor.on('scroll', () => {
            const scrollInfo = codeMirrorEditor.getScrollInfo();
            const lineNumbers = document.getElementById('line-numbers');
            if (lineNumbers) {
                lineNumbers.scrollTop = scrollInfo.top;
            }
        });

        // Update line numbers on content change
        let isEditorChanged = false;
        codeMirrorEditor.on('change', () => {
            isEditorChanged = true;
            updateLineNumbers();
        });

        // Initial line numbers update
        updateLineNumbers();

        // Format button handler
        const formatBtn = document.getElementById('format-btn');
        if (formatBtn) {
            formatBtn.addEventListener('click', () => {
                codeMirrorEditor.execCommand('indentAuto');
                updateLineNumbers();
            });
        }

        // Tab switching and Submit button handling
        const submitBtn = document.getElementById('submit-btn');
        const editorTabs = document.querySelectorAll('.editor-tab');

        editorTabs.forEach(tab => {
            tab.addEventListener('click', (e) => {
                e.preventDefault();
                switchToTab(tab);
            });
        });

        if (submitBtn) {
            submitBtn.addEventListener('click', () => {
                const resultsTab = document.querySelector('.editor-tab[data-tab="results"]');
                if (resultsTab) {
                    switchToTab(resultsTab);
                }
            });
        }

        // Sahifadan chiqishdan oldin ogohlantirish
        window.addEventListener('beforeunload', (event) => {
            if (isEditorChanged) {
                event.preventDefault();
                event.returnValue = '';
            }
        });

        // Formani yuborishda o'zgartirish holatini yangilash
        document.querySelectorAll("form").forEach(form => {
            form.addEventListener("submit", function (event) {
                const hiddenInput = form.querySelector("input[name='code']");
                if (hiddenInput) {
                    hiddenInput.value = codeMirrorEditor.getValue();
                    isEditorChanged = false;
                }
            });
        });
    }

    // Dasturni ishga tushurish
    checkUrlAndSetTab();
    initializeEditor();
});