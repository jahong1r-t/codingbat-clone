/**
 * Storage Service - Handles all localStorage operations
 */
const StorageService = {
    // Keys for localStorage
    KEYS: {
        USERS: 'code_challenger_users',
        CURRENT_USER: 'code_challenger_current_user',
        PROBLEMS: 'code_challenger_problems',
        USER_PROGRESS: 'code_challenger_user_progress',
    },

    /**
     * Initialize storage with default data if empty
     */
    init() {

        if (!this.getItem(this.KEYS.PROBLEMS)) {
            this.setItem(this.KEYS.PROBLEMS, [{
                id: '1',
                title: 'Reverse a String',
                difficulty: 'easy',
                dateAdded: '2024-01-01T00:00:00.000Z',
                description: `
            <p>Write a method that reverses a string.</p>
            <p>The input string is given as an array of characters.</p>
            <p>You must do this by modifying the input array in-place with O(1) extra memory.</p>
            <p><strong>Example:</strong></p>
            <pre>Input: ["h","e","l","l","o"]
Output: ["o","l","l","e","h"]</pre>
          `,
                template: `public class Solution {
    public String reverse(String str) {
        // Write your code here
        
    }
}`,
                testCases: [{
                    input: 'hello', output: 'olleh', hidden: false
                }, {
                    input: 'java', output: 'avaj', hidden: false
                }, {
                    input: 'racecar', output: 'racecar', hidden: true
                }]
            }, {
                id: '2',
                title: 'Fibonacci Number',
                difficulty: 'medium',
                dateAdded: '2024-01-02T00:00:00.000Z',
                description: `
            <p>The Fibonacci numbers, commonly denoted F(n), form a sequence such that each number is the sum of the two preceding ones, starting from 0 and 1.</p>
            <p>That is: F(0) = 0, F(1) = 1, and F(n) = F(n-1) + F(n-2) for n > 1.</p>
            <p>Given n, calculate F(n).</p>
            <p><strong>Example:</strong></p>
            <pre>Input: n = 4
Output: 3
Explanation: F(4) = F(3) + F(2) = 2 + 1 = 3.</pre>
          `,
                template: `public class Solution {
    public int fibonacci(int n) {
        // Write your code here
        
    }
}`,
                testCases: [{
                    input: '4', output: '3', hidden: false
                }, {
                    input: '10', output: '55', hidden: false
                }, {
                    input: '20', output: '6765', hidden: true
                }]
            }, {
                id: "3",
                title: "Factorial",
                difficulty: "easy",
                dateAdded: "2024-01-03T00:00:00.000Z",
                description: "<p>Given a non-negative integer <code>n</code>, return the factorial of <code>n</code>.</p><p>That is, <code>factorial(n) = n * (n-1) * ... * 1</code>, and <code>factorial(0) = 1</code>.</p><pre>Input: n = 5\nOutput: 120</pre>",
                template: "public class Solution {\n    public int factorial(int n) {\n        // Write your code here\n\n    }\n}",
                testCases: [{input: "5", output: "120", hidden: false}, {
                    input: "0",
                    output: "1",
                    hidden: false
                }, {input: "10", output: "3628800", hidden: true}]
            }, {
                id: "4",
                title: "Sum of Digits",
                difficulty: "easy",
                dateAdded: "2024-01-04T00:00:00.000Z",
                description: "<p>Given a positive integer <code>n</code>, return the sum of its digits.</p><pre>Input: n = 123\nOutput: 6</pre>",
                template: "public class Solution {\n    public int sumOfDigits(int n) {\n        // Write your code here\n\n    }\n}",
                testCases: [{input: "123", output: "6", hidden: false}, {
                    input: "999",
                    output: "27",
                    hidden: false
                }, {input: "123456", output: "21", hidden: true}]
            }, {
                id: "5",
                title: "Reverse Integer",
                difficulty: "easy",
                dateAdded: "2024-01-05T00:00:00.000Z",
                description: "<p>Given a signed integer <code>n</code>, return its digits reversed.</p><pre>Input: n = -123\nOutput: -321</pre>",
                template: "public class Solution {\n    public int reverse(int n) {\n        // Write your code here\n\n    }\n}",
                testCases: [{input: "123", output: "321", hidden: false}, {
                    input: "-456",
                    output: "-654",
                    hidden: false
                }, {input: "1000", output: "1", hidden: true}]
            }, {
                id: "6",
                title: "Count Set Bits",
                difficulty: "medium",
                dateAdded: "2024-01-06T00:00:00.000Z",
                description: "<p>Given a positive integer <code>n</code>, return the number of 1's in its binary representation.</p><pre>Input: n = 5\nOutput: 2</pre>",
                template: "public class Solution {\n    public int countSetBits(int n) {\n        // Write your code here\n\n    }\n}",
                testCases: [{input: "5", output: "2", hidden: false}, {
                    input: "15",
                    output: "4",
                    hidden: false
                }, {input: "1023", output: "10", hidden: true}]
            }, {
                id: "7",
                title: "Check Prime",
                difficulty: "medium",
                dateAdded: "2024-01-07T00:00:00.000Z",
                description: "<p>Determine if <code>n</code> is a prime number. Return 1 if prime, 0 otherwise.</p><pre>Input: n = 7\nOutput: 1</pre>",
                template: "public class Solution {\n    public int isPrime(int n) {\n        // Write your code here\n\n    }\n}",
                testCases: [{input: "7", output: "1", hidden: false}, {
                    input: "10",
                    output: "0",
                    hidden: false
                }, {input: "101", output: "1", hidden: true}]
            }, {
                id: "8",
                title: "Nth Even Number",
                difficulty: "easy",
                dateAdded: "2024-01-08T00:00:00.000Z",
                description: "<p>Return the n-th even number (starting from 0).</p><pre>Input: n = 3\nOutput: 4</pre>",
                template: "public class Solution {\n    public int nthEven(int n) {\n        // Write your code here\n\n    }\n}",
                testCases: [{input: "1", output: "0", hidden: false}, {
                    input: "3",
                    output: "4",
                    hidden: false
                }, {input: "1000", output: "1998", hidden: true}]
            }, {
                id: "9",
                title: "Power of Two",
                difficulty: "medium",
                dateAdded: "2024-01-09T00:00:00.000Z",
                description: "<p>Check if the given number <code>n</code> is a power of 2.</p><pre>Input: n = 8\nOutput: 1</pre>",
                template: "public class Solution {\n    public int isPowerOfTwo(int n) {\n        // Write your code here\n\n    }\n}",
                testCases: [{input: "8", output: "1", hidden: false}, {
                    input: "10",
                    output: "0",
                    hidden: false
                }, {input: "1024", output: "1", hidden: true}]
            }, {
                id: "10",
                title: "Sum of Even Numbers",
                difficulty: "easy",
                dateAdded: "2024-01-10T00:00:00.000Z",
                description: "<p>Return the sum of all even numbers from 1 to <code>n</code> (inclusive).</p><pre>Input: n = 10\nOutput: 30</pre>",
                template: "public class Solution {\n    public int sumEven(int n) {\n        // Write your code here\n\n    }\n}",
                testCases: [
                    {input: "10", output: "30", hidden: false},
                    {
                        input: "5",
                        output: "6",
                        hidden: false
                    }, {input: "100", output: "2550", hidden: true}]
            }, {
                id: "11",
                title: "GCD of Two Numbers",
                difficulty: "medium",
                dateAdded: "2024-01-11T00:00:00.000Z",
                description: "<p>Find the greatest common divisor (GCD) of two numbers.</p><pre>Input: a = 12, b = 18\nOutput: 6</pre>",
                template: "public class Solution {\n    public int gcd(int a, int b) {\n        // Write your code here\n\n    }\n}",
                testCases: [{input: "12 18", output: "6", hidden: false}, {
                    input: "100 85",
                    output: "5",
                    hidden: false
                }, {input: "270 192", output: "6", hidden: true}]
            }, {
                id: "12",
                title: "Count Divisors",
                difficulty: "medium",
                dateAdded: "2024-01-12T00:00:00.000Z",
                description: "<p>Given an integer <code>n</code>, return how many positive integers divide <code>n</code> exactly.</p><pre>Input: n = 6\nOutput: 4 (1, 2, 3, 6)</pre>",
                template: "public class Solution {\n    public int countDivisors(int n) {\n        // Write your code here\n\n    }\n}",
                testCases: [{input: "6", output: "4", hidden: false}, {
                    input: "10",
                    output: "4",
                    hidden: false
                }, {input: "100", output: "9", hidden: true}]
            }]);
        }

        // Initialize user progress if not exists
        if (!this.getItem(this.KEYS.USER_PROGRESS)) {
            this.setItem(this.KEYS.USER_PROGRESS, {});
        }
    },

    /**
     * Get item from localStorage
     * @param {string} key - Storage key
     * @returns {any} - Parsed item or null if not found
     */
    getItem(key) {
        const item = localStorage.getItem(key);
        return item ? JSON.parse(item) : null;
    },

    /**
     * Set item in localStorage
     * @param {string} key - Storage key
     * @param {any} value - Value to store
     */
    setItem(key, value) {
        localStorage.setItem(key, JSON.stringify(value));
    },

    /**
     * Remove item from localStorage
     * @param {string} key - Storage key
     */
    removeItem(key) {
        localStorage.removeItem(key);
    },

    /**
     * Get all users
     * @returns {Array} - Array of user objects
     */
    getUsers() {
        return this.getItem(this.KEYS.USERS) || [];
    },

    /**
     * Add new user
     * @param {object} user - User object with username and password
     * @returns {boolean} - Success status
     */
    addUser(user) {
        const users = this.getUsers();

        // Check if username already exists
        if (users.some(u => u.username === user.username)) {
            return false;
        }

        users.push(user);
        this.setItem(this.KEYS.USERS, users);
        return true;
    },

    /**
     * Authenticate user
     * @param {string} username - Username
     * @param {string} password - Password
     * @returns {object|null} - User object if authenticated, null otherwise
     */


    /**
     * Get current user
     * @returns {object|null} - Current user object or null
     */
    getCurrentUser() {
        return this.getItem(this.KEYS.CURRENT_USER);
    },


    /**
     * Get all problems
     * @returns {Array} - Array of problem objects
     */
    getProblems() {
        return this.getItem(this.KEYS.PROBLEMS) || [];
    },

    /**
     * Get problem by ID
     * @param {string} id - Problem ID
     * @returns {object|null} - Problem object or null
     */
    getProblemById(id) {
        const problems = this.getProblems();
        return problems.find(p => p.id === id) || null;
    },

    /**
     * Add new problem
     * @param {object} problem - Problem object
     */
    addProblem(problem) {
        const problems = this.getProblems();
        // Generate a unique ID and add date
        problem.id = Date.now().toString();
        problem.dateAdded = new Date().toISOString();
        problems.push(problem);
        this.setItem(this.KEYS.PROBLEMS, problems);
        return problem;
    },

    /**
     * Update problem
     * @param {string} id - Problem ID
     * @param {object} updatedProblem - Updated problem object
     * @returns {boolean} - Success status
     */
    updateProblem(id, updatedProblem) {
        const problems = this.getProblems();
        const index = problems.findIndex(p => p.id === id);

        if (index === -1) {
            return false;
        }

        problems[index] = {...problems[index], ...updatedProblem};
        this.setItem(this.KEYS.PROBLEMS, problems);
        return true;
    },

    /**
     * Delete problem
     * @param {string} id - Problem ID
     * @returns {boolean} - Success status
     */
    deleteProblem(id) {
        const problems = this.getProblems();
        const newProblems = problems.filter(p => p.id !== id);

        if (newProblems.length === problems.length) {
            return false;
        }

        this.setItem(this.KEYS.PROBLEMS, newProblems);
        return true;
    },






};

// Initialize storage when the script loads
StorageService.init();
