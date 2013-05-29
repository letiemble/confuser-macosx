Packaging for the Confuser tool (https://confuser.codeplex.com/)


### Description

This project aims to provide an OS X installer for the Confuser tool. It contains:

- Confuser console
- Confuser MSBuild task/target

### Building

After cloning the project, launch `make` to generate the package.

### Installer

The packager will:
- install the binaries under `/Library/Frameworks/Mono.framework/Libraries/mono/confuser`
- install the MSBuild target under `/Library/Frameworks/Mono.framework/Libraries/mono/4.0`
- register the various assemblies into the GAC
- install a command line wrapper `/usr/bin/confuser` for the console

### Command line use

The Confuser console is invoked like this:

    $> confuser <Confuser Configuration File>

See the Confuser wiki for more details.

### MSBuild use

The MSBuild integration requires the edition of the the project file (a `.csproj` file for a C# project) to add the target:

    <Import Project="$(MSBuildBinPath)\Confuser.targets" />

The Confuser configuration file must bear the same name as the project file.
For example, for the `MyGreatProject.csproj` file, configuration will be named `MyGreatProject.Release.crproj` for the Release configuration.

When the project is build (via `xbuild`), the `Confuse` target is called right after the build.
