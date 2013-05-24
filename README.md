Packaging for the Confuser tool (https://confuser.codeplex.com/)

### Description

This project aims to provide an OS X installer for the Confuser tool. It contains:

- Confuser console
- Confuser MSBuild task/target

### Details

The packager:
- installs the binaries under `/Library/Frameworks/Mono.framework/Libraries/mono/confuser`
- installs the MSBuild target under `/Library/Frameworks/Mono.framework/Libraries/mono/4.0`
- registers the assemblies into the GAC
