# Contributing to Semester Student Ride App 🤝

Thank you for your interest in contributing to the Semester Student Ride App! This document provides guidelines for contributing to the project.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.3+
- Dart 3.0+
- Git
- Firebase CLI
- Android Studio / VS Code

### Setup
1. Fork the repository
2. Clone your fork: `git clone <your-fork-url>`
3. Install dependencies: `flutter pub get`
4. Create a feature branch: `git checkout -b feature/your-feature-name`

## 📝 Development Guidelines

### Code Style
- Follow Dart/Flutter conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Commit Messages
Use conventional commits format:
```
type(scope): description

Examples:
feat(auth): add OTP verification
fix(booking): resolve Firebase connection issue
docs(readme): update installation instructions
```

### Pull Request Process
1. Ensure your code follows the project's style guidelines
2. Add tests for new functionality
3. Update documentation if needed
4. Create a pull request with a clear description

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/booking_service_test.dart

# Run with coverage
flutter test --coverage
```

### Test Requirements
- New features must include unit tests
- Critical paths must have integration tests
- UI changes should include widget tests

## 📱 Feature Development

### Before Starting
1. Check existing issues and discussions
2. Create an issue for major features
3. Discuss the approach with maintainers

### During Development
1. Keep commits small and focused
2. Test your changes thoroughly
3. Update documentation as needed
4. Follow the existing code patterns

### After Development
1. Run all tests to ensure nothing is broken
2. Update CHANGELOG.md if applicable
3. Create a pull request with detailed description
4. Respond to review feedback promptly

## 🐛 Bug Reports

### Before Reporting
1. Check if the issue already exists
2. Try to reproduce the issue
3. Check the latest version

### Bug Report Template
```markdown
**Bug Description**
A clear description of the bug.

**Steps to Reproduce**
1. Go to '...'
2. Click on '....'
3. See error

**Expected Behavior**
What you expected to happen.

**Actual Behavior**
What actually happened.

**Environment**
- Flutter version: [e.g., 3.3.0]
- Dart version: [e.g., 3.0.0]
- Platform: [e.g., Android, iOS, Web]

**Additional Context**
Any other relevant information.
```

## ✨ Feature Requests

### Before Requesting
1. Check if the feature already exists
2. Consider if it fits the project's scope
3. Think about the implementation approach

### Feature Request Template
```markdown
**Feature Description**
A clear description of the feature.

**Use Case**
Why would this feature be useful?

**Proposed Solution**
How do you think this should be implemented?

**Alternatives**
Any alternative solutions you've considered.

**Additional Context**
Any other relevant information.
```

## 📚 Documentation

### Code Documentation
- Document public APIs
- Add inline comments for complex logic
- Update README.md for new features
- Keep CHANGELOG.md updated

### Documentation Standards
- Use clear, concise language
- Include code examples where helpful
- Keep documentation up to date
- Follow the existing documentation style

## 🔒 Security

### Security Issues
If you discover a security vulnerability, please:
1. **DO NOT** create a public issue
2. Email the maintainers directly
3. Include detailed information about the vulnerability
4. Wait for a response before disclosing publicly

### Security Guidelines
- Never commit sensitive information (API keys, passwords, etc.)
- Use environment variables for configuration
- Follow security best practices
- Review code for security vulnerabilities

## 🏷️ Release Process

### Version Numbering
We follow semantic versioning (MAJOR.MINOR.PATCH):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Checklist
- [ ] All tests passing
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version number updated
- [ ] Release notes prepared

## 📞 Getting Help

### Resources
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Project Issues](https://github.com/your-repo/issues)

### Community
- Join our Discord server
- Follow us on Twitter
- Star the repository

## 📄 License

By contributing to this project, you agree that your contributions will be licensed under the same license as the project.

## 🙏 Recognition

Contributors will be recognized in:
- CONTRIBUTORS.md file
- Release notes
- Project documentation

Thank you for contributing to the Semester Student Ride App! 🚀
