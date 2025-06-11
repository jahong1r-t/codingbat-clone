document.addEventListener('DOMContentLoaded', () => {
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
                hiddenInput.value = codeMirrorEditor.getValue(); // Use codeMirrorEditor
                console.log("Form submitted with code:", hiddenInput.value); // Debug
            } else {
                console.error("Hidden input not found!");
            }
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
    codeMirrorEditor.on('change', () => {
        updateLineNumbers();
        console.log("Editor content changed:", codeMirrorEditor.getValue()); // Debug
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

    function switchToTab(targetTab) {
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
        } else {
            console.error(`Container with id ${containerId} not found`);
        }
    }

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
                console.log('Switched to Test Results tab');
            } else {
                console.error('Test Results tab not found');
            }
        });
    }
});
