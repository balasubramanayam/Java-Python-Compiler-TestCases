This is for Java POST method:
http://localhost:8080/execute/java
{
  "code": "public class Palindrome { public boolean isPalindrome(String str) { if (str == null) { return false; } String reversed = new StringBuilder(str).reverse().toString(); return str.equalsIgnoreCase(reversed); } public boolean isPalindrome(int num) { return isPalindrome(String.valueOf(num)); } public boolean isPhrasePalindrome(String str) { if (str == null) { return false; } String cleanedStr = str.replaceAll(\"\\\\s+\", \"\").toLowerCase(); return isPalindrome(cleanedStr);}  }",
  
  "testCases": "import org.junit.Test;\nimport static org.junit.Assert.*;\n\npublic class PalindromeTest {\n    @Test\n    public void testMethod1() {\n        Palindrome palindrome = new Palindrome();\n        assertTrue(palindrome.isPalindrome(\"Madam\"));\n    }\n\n    @Test\n    public void testMethod2() {\n        Palindrome palindrome = new Palindrome();\n        assertFalse(palindrome.isPalindrome(\"Hello\"));\n    }\n\n    @Test\n    public void testMethod3() {\n        Palindrome palindrome = new Palindrome();\n        assertTrue(palindrome.isPalindrome(121));\n    }\n\n    @Test\n    public void testMethod4() {\n        Palindrome palindrome = new Palindrome();\n        assertFalse(palindrome.isPalindrome(123));\n    }\n\n    @Test\n    public void testMethod5() {\n        Palindrome palindrome = new Palindrome();\n        assertTrue(palindrome.isPhrasePalindrome(\"A Santa at NASA\"));\n    }\n}\n",
  
  "testClassName": "PalindromeTest"
}

This is for Python POST method:
http://localhost:8080/execute/python
{
  "code": "def reverse_string(s):\n    return s[::-1]",
  "testCases": "from user_code import reverse_string\ndef test_simple():\n    assert reverse_string('hello') == 'olleh'\ndef test_empty():\n    assert reverse_string('') == ''\ndef test_palindrome():\n    assert reverse_string('madam') == 'madam'\ndef test_spaces():\n    assert reverse_string('hello world') == 'dlrow olleh'\ndef test_numbers():\n    assert reverse_string('12345') == '54321'\ndef test_special_chars():\n    assert reverse_string('!@# $%^') == '^%$ #@!'\n",
  "testClassName": "test_reverse_string.py"
}
