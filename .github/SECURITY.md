# Security Policy

## Supported Versions

We release patches for security vulnerabilities in the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take security bugs seriously. We appreciate your efforts to responsibly disclose your findings, and will make every effort to acknowledge your contributions.

### How to Report

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report them via email to: security@semester-ride-app.com

You should receive a response within 48 hours. If for some reason you do not, please follow up via email to ensure we received your original message.

### What to Include

Please include the following information in your report:

- Type of issue (e.g. buffer overflow, SQL injection, cross-site scripting, etc.)
- Full paths of source file(s) related to the manifestation of the issue
- The location of the affected source code (tag/branch/commit or direct URL)
- Any special configuration required to reproduce the issue
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit it

### What to Expect

After you submit a report, we will:

1. Confirm receipt of your vulnerability report within 48 hours
2. Provide regular updates on our progress
3. Credit you in our security advisories (unless you prefer to remain anonymous)

### Security Best Practices

When developing for this project, please follow these security best practices:

- Never commit sensitive information (API keys, passwords, tokens)
- Use environment variables for configuration
- Validate all user inputs
- Follow the principle of least privilege
- Keep dependencies updated
- Use secure coding practices
- Regular security audits

### Security Measures

We implement the following security measures:

- Regular dependency updates
- Automated security scanning
- Code review process
- Secure coding guidelines
- Regular security audits

### Disclosure Policy

We follow a coordinated disclosure policy:

1. **Initial Report**: Security issues are reported privately
2. **Investigation**: We investigate and confirm the issue
3. **Fix Development**: We develop and test a fix
4. **Disclosure**: We coordinate public disclosure with the reporter
5. **Release**: We release the fix and security advisory

### Recognition

We recognize security researchers who responsibly disclose vulnerabilities:

- Credit in security advisories
- Recognition in project documentation
- Special thanks in release notes

### Contact Information

- **Security Email**: security@semester-ride-app.com
- **General Support**: support@semester-ride-app.com
- **Project Issues**: Use GitHub Issues for non-security issues

Thank you for helping keep the Semester Student Ride App secure! 🔒
