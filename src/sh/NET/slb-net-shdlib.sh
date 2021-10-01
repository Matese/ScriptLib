#!/bin/sh
#slb-net-shdlib.sh Version 0.1
#..................................................................................
# Description:
#   TODO.
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> todo
#..................................................................................

#..................................................................................
# The main entry point for the script
#
main()
{
    # default help
    . slb-helper.sh && return 0

    # parse the arguments
    . slb-argadd.sh "$@"

    # default arguments
    if [ -z ${d+x} ] || [ "${d}" == "" ] || [ "${d}" == "-d" ]; then d=$PWD; fi

    # generate structure
    scaffold $d
}

#..................................................................................
# Generate SharedLib structure
#
scaffold()
{
    mkdir -p "$1"
    mkdir -p "$1/src"

    genGit $1
    genMsbuild $1
}

#..................................................................................
# Generate 'Git' dir and files
#
genGit()
{
    mkdir -p             "$1/src/Git"
                        >"$1/src/Git/.gitattributes"
    genGit_gitattributes "$1/src/Git/.gitattributes"
                        >"$1/src/Git/.gitignore"
    genGit_gitignore     "$1/src/Git/.gitignore"
}

#..................................................................................
# Generate '.gitattributes' file content
#
genGit_gitattributes()
{
    echo "###############################################################################" >> $1
    echo "# Set default behavior to automatically normalize line endings." >> $1
    echo "###############################################################################" >> $1
    echo "* text=auto" >> $1
    echo "" >> $1
    echo "###############################################################################" >> $1
    echo "# Set default behavior for command prompt diff." >> $1
    echo "#" >> $1
    echo "# This is need for earlier builds of msysgit that does not have it on by" >> $1
    echo "# default for csharp files." >> $1
    echo "# Note: This is only used by command line" >> $1
    echo "###############################################################################" >> $1
    echo "#*.cs     diff=csharp" >> $1
    echo "" >> $1
    echo "###############################################################################" >> $1
    echo "# Set the merge driver for project and solution files" >> $1
    echo "#" >> $1
    echo "# Merging from the command prompt will add diff markers to the files if there" >> $1
    echo "# are conflicts (Merging from VS is not affected by the settings below, in VS" >> $1
    echo "# the diff markers are never inserted). Diff markers may cause the following" >> $1
    echo "# file extensions to fail to load in VS. An alternative would be to treat" >> $1
    echo "# these files as binary and thus will always conflict and require user" >> $1
    echo "# intervention with every merge. To do so, just uncomment the entries below" >> $1
    echo "###############################################################################" >> $1
    echo "#*.sln       merge=binary" >> $1
    echo "#*.csproj    merge=binary" >> $1
    echo "#*.vbproj    merge=binary" >> $1
    echo "#*.vcxproj   merge=binary" >> $1
    echo "#*.vcproj    merge=binary" >> $1
    echo "#*.dbproj    merge=binary" >> $1
    echo "#*.fsproj    merge=binary" >> $1
    echo "#*.lsproj    merge=binary" >> $1
    echo "#*.wixproj   merge=binary" >> $1
    echo "#*.modelproj merge=binary" >> $1
    echo "#*.sqlproj   merge=binary" >> $1
    echo "#*.wwaproj   merge=binary" >> $1
    echo "" >> $1
    echo "###############################################################################" >> $1
    echo "# behavior for image files" >> $1
    echo "#" >> $1
    echo "# image files are treated as binary by default." >> $1
    echo "###############################################################################" >> $1
    echo "#*.jpg   binary" >> $1
    echo "#*.png   binary" >> $1
    echo "#*.gif   binary" >> $1
    echo "" >> $1
    echo "###############################################################################" >> $1
    echo "# diff behavior for common document formats" >> $1
    echo "#" >> $1
    echo "# Convert binary document formats to text before diffing them. This feature" >> $1
    echo "# is only available from the command line. Turn it on by uncommenting the" >> $1
    echo "# entries below." >> $1
    echo "###############################################################################" >> $1
    echo "#*.doc   diff=astextplain" >> $1
    echo "#*.DOC   diff=astextplain" >> $1
    echo "#*.docx  diff=astextplain" >> $1
    echo "#*.DOCX  diff=astextplain" >> $1
    echo "#*.dot   diff=astextplain" >> $1
    echo "#*.DOT   diff=astextplain" >> $1
    echo "#*.pdf   diff=astextplain" >> $1
    echo "#*.PDF   diff=astextplain" >> $1
    echo "#*.rtf   diff=astextplain" >> $1
    echo "#*.RTF   diff=astextplain" >> $1
}

#..................................................................................
# Generate '.gitignore' file content
#
genGit_gitignore()
{
    echo "## Ignore Visual Studio temporary files, build results, and" >> $1
    echo "## files generated by popular Visual Studio add-ons." >> $1
    echo "##" >> $1
    echo "## Get latest from https://github.com/github/gitignore/blob/master/VisualStudio.gitignore" >> $1
    echo "" >> $1
    echo "# User-specific files" >> $1
    echo "*.rsuser" >> $1
    echo "*.suo" >> $1
    echo "*.user" >> $1
    echo "*.userosscache" >> $1
    echo "*.sln.docstates" >> $1
    echo "" >> $1
    echo "# User-specific files (MonoDevelop/Xamarin Studio)" >> $1
    echo "*.userprefs" >> $1
    echo "" >> $1
    echo "# Mono auto generated files" >> $1
    echo "mono_crash.*" >> $1
    echo "" >> $1
    echo "# Build results" >> $1
    echo "[Dd]ebug/" >> $1
    echo "[Dd]ebugPublic/" >> $1
    echo "[Rr]elease/" >> $1
    echo "[Rr]eleases/" >> $1
    echo "x64/" >> $1
    echo "x86/" >> $1
    echo "[Ww][Ii][Nn]32/" >> $1
    echo "[Aa][Rr][Mm]/" >> $1
    echo "[Aa][Rr][Mm]64/" >> $1
    echo "bld/" >> $1
    echo "[Bb]in/" >> $1
    echo "[Oo]bj/" >> $1
    echo "[Ll]og/" >> $1
    echo "[Ll]ogs/" >> $1
    echo "" >> $1
    echo "# Visual Studio 2015/2017 cache/options directory" >> $1
    echo ".vs/" >> $1
    echo "# Uncomment if you have tasks that create the project's static files in wwwroot" >> $1
    echo "#wwwroot/" >> $1
    echo "" >> $1
    echo "# Visual Studio 2017 auto generated files" >> $1
    echo "Generated\ Files/" >> $1
    echo "" >> $1
    echo "# MSTest test Results" >> $1
    echo "[Tt]est[Rr]esult*/" >> $1
    echo "[Bb]uild[Ll]og.*" >> $1
    echo "" >> $1
    echo "# NUnit" >> $1
    echo "*.VisualState.xml" >> $1
    echo "TestResult.xml" >> $1
    echo "nunit-*.xml" >> $1
    echo "" >> $1
    echo "# Build Results of an ATL Project" >> $1
    echo "[Dd]ebugPS/" >> $1
    echo "[Rr]eleasePS/" >> $1
    echo "dlldata.c" >> $1
    echo "" >> $1
    echo "# Benchmark Results" >> $1
    echo "BenchmarkDotNet.Artifacts/" >> $1
    echo "" >> $1
    echo "# .NET Core" >> $1
    echo "project.lock.json" >> $1
    echo "project.fragment.lock.json" >> $1
    echo "artifacts/" >> $1
    echo "" >> $1
    echo "# ASP.NET Scaffolding" >> $1
    echo "ScaffoldingReadMe.txt" >> $1
    echo "" >> $1
    echo "# StyleCop" >> $1
    echo "StyleCopReport.xml" >> $1
    echo "" >> $1
    echo "# Files built by Visual Studio" >> $1
    echo "*_i.c" >> $1
    echo "*_p.c" >> $1
    echo "*_h.h" >> $1
    echo "*.ilk" >> $1
    echo "*.meta" >> $1
    echo "*.obj" >> $1
    echo "*.iobj" >> $1
    echo "*.pch" >> $1
    echo "*.pdb" >> $1
    echo "*.ipdb" >> $1
    echo "*.pgc" >> $1
    echo "*.pgd" >> $1
    echo "*.rsp" >> $1
    echo "*.sbr" >> $1
    echo "*.tlb" >> $1
    echo "*.tli" >> $1
    echo "*.tlh" >> $1
    echo "*.tmp" >> $1
    echo "*.tmp_proj" >> $1
    echo "*_wpftmp.csproj" >> $1
    echo "*.log" >> $1
    echo "*.tlog" >> $1
    echo "*.vspscc" >> $1
    echo "*.vssscc" >> $1
    echo ".builds" >> $1
    echo "*.pidb" >> $1
    echo "*.svclog" >> $1
    echo "*.scc" >> $1
    echo "" >> $1
    echo "# Chutzpah Test files" >> $1
    echo "_Chutzpah*" >> $1
    echo "" >> $1
    echo "# Visual C++ cache files" >> $1
    echo "ipch/" >> $1
    echo "*.aps" >> $1
    echo "*.ncb" >> $1
    echo "*.opendb" >> $1
    echo "*.opensdf" >> $1
    echo "*.sdf" >> $1
    echo "*.cachefile" >> $1
    echo "*.VC.db" >> $1
    echo "*.VC.VC.opendb" >> $1
    echo "" >> $1
    echo "# Visual Studio profiler" >> $1
    echo "*.psess" >> $1
    echo "*.vsp" >> $1
    echo "*.vspx" >> $1
    echo "*.sap" >> $1
    echo "" >> $1
    echo "# Visual Studio Trace Files" >> $1
    echo "*.e2e" >> $1
    echo "" >> $1
    echo "# TFS 2012 Local Workspace" >> $1
    echo "$tf/" >> $1
    echo "" >> $1
    echo "# Guidance Automation Toolkit" >> $1
    echo "*.gpState" >> $1
    echo "" >> $1
    echo "# ReSharper is a .NET coding add-in" >> $1
    echo "_ReSharper*/" >> $1
    echo "*.[Rr]e[Ss]harper" >> $1
    echo "*.DotSettings.user" >> $1
    echo "" >> $1
    echo "# TeamCity is a build add-in" >> $1
    echo "_TeamCity*" >> $1
    echo "" >> $1
    echo "# DotCover is a Code Coverage Tool" >> $1
    echo "*.dotCover" >> $1
    echo "" >> $1
    echo "# AxoCover is a Code Coverage Tool" >> $1
    echo ".axoCover/*" >> $1
    echo "!.axoCover/settings.json" >> $1
    echo "" >> $1
    echo "# Coverlet is a free, cross platform Code Coverage Tool" >> $1
    echo "coverage*.json" >> $1
    echo "coverage*.xml" >> $1
    echo "coverage*.info" >> $1
    echo "" >> $1
    echo "# Visual Studio code coverage results" >> $1
    echo "*.coverage" >> $1
    echo "*.coveragexml" >> $1
    echo "" >> $1
    echo "# NCrunch" >> $1
    echo "_NCrunch_*" >> $1
    echo ".*crunch*.local.xml" >> $1
    echo "nCrunchTemp_*" >> $1
    echo "" >> $1
    echo "# MightyMoose" >> $1
    echo "*.mm.*" >> $1
    echo "AutoTest.Net/" >> $1
    echo "" >> $1
    echo "# Web workbench (sass)" >> $1
    echo ".sass-cache/" >> $1
    echo "" >> $1
    echo "# Installshield output folder" >> $1
    echo "[Ee]xpress/" >> $1
    echo "" >> $1
    echo "# DocProject is a documentation generator add-in" >> $1
    echo "DocProject/buildhelp/" >> $1
    echo "DocProject/Help/*.HxT" >> $1
    echo "DocProject/Help/*.HxC" >> $1
    echo "DocProject/Help/*.hhc" >> $1
    echo "DocProject/Help/*.hhk" >> $1
    echo "DocProject/Help/*.hhp" >> $1
    echo "DocProject/Help/Html2" >> $1
    echo "DocProject/Help/html" >> $1
    echo "" >> $1
    echo "# Click-Once directory" >> $1
    echo "publish/" >> $1
    echo "" >> $1
    echo "# Publish Web Output" >> $1
    echo "*.[Pp]ublish.xml" >> $1
    echo "*.azurePubxml" >> $1
    echo "# Note: Comment the next line if you want to checkin your web deploy settings," >> $1
    echo "# but database connection strings (with potential passwords) will be unencrypted" >> $1
    echo "*.pubxml" >> $1
    echo "*.publishproj" >> $1
    echo "" >> $1
    echo "# Microsoft Azure Web App publish settings. Comment the next line if you want to" >> $1
    echo "# checkin your Azure Web App publish settings, but sensitive information contained" >> $1
    echo "# in these scripts will be unencrypted" >> $1
    echo "PublishScripts/" >> $1
    echo "" >> $1
    echo "# NuGet Packages" >> $1
    echo "*.nupkg" >> $1
    echo "# NuGet Symbol Packages" >> $1
    echo "*.snupkg" >> $1
    echo "# The packages folder can be ignored because of Package Restore" >> $1
    echo "**/[Pp]ackages/*" >> $1
    echo "# except build/, which is used as an MSBuild target." >> $1
    echo "!**/[Pp]ackages/build/" >> $1
    echo "# Uncomment if necessary however generally it will be regenerated when needed" >> $1
    echo "#!**/[Pp]ackages/repositories.config" >> $1
    echo "# NuGet v3's project.json files produces more ignorable files" >> $1
    echo "*.nuget.props" >> $1
    echo "*.nuget.targets" >> $1
    echo "" >> $1
    echo "# Nuget personal access tokens and Credentials" >> $1
    echo "nuget.config" >> $1
    echo "" >> $1
    echo "# Microsoft Azure Build Output" >> $1
    echo "csx/" >> $1
    echo "*.build.csdef" >> $1
    echo "" >> $1
    echo "# Microsoft Azure Emulator" >> $1
    echo "ecf/" >> $1
    echo "rcf/" >> $1
    echo "" >> $1
    echo "# Windows Store app package directories and files" >> $1
    echo "AppPackages/" >> $1
    echo "BundleArtifacts/" >> $1
    echo "Package.StoreAssociation.xml" >> $1
    echo "_pkginfo.txt" >> $1
    echo "*.appx" >> $1
    echo "*.appxbundle" >> $1
    echo "*.appxupload" >> $1
    echo "" >> $1
    echo "# Visual Studio cache files" >> $1
    echo "# files ending in .cache can be ignored" >> $1
    echo "*.[Cc]ache" >> $1
    echo "# but keep track of directories ending in .cache" >> $1
    echo "!?*.[Cc]ache/" >> $1
    echo "" >> $1
    echo "# Others" >> $1
    echo "ClientBin/" >> $1
    echo "~$*" >> $1
    echo "*~" >> $1
    echo "*.dbmdl" >> $1
    echo "*.dbproj.schemaview" >> $1
    echo "*.jfm" >> $1
    echo "*.pfx" >> $1
    echo "*.publishsettings" >> $1
    echo "orleans.codegen.cs" >> $1
    echo "" >> $1
    echo "# Including strong name files can present a security risk" >> $1
    echo "# (https://github.com/github/gitignore/pull/2483#issue-259490424)" >> $1
    echo "#*.snk" >> $1
    echo "" >> $1
    echo "# Since there are multiple workflows, uncomment next line to ignore bower_components" >> $1
    echo "# (https://github.com/github/gitignore/pull/1529#issuecomment-104372622)" >> $1
    echo "#bower_components/" >> $1
    echo "" >> $1
    echo "# RIA/Silverlight projects" >> $1
    echo "Generated_Code/" >> $1
    echo "" >> $1
    echo "# Backup & report files from converting an old project file" >> $1
    echo "# to a newer Visual Studio version. Backup files are not needed," >> $1
    echo "# because we have git ;-)" >> $1
    echo "_UpgradeReport_Files/" >> $1
    echo "Backup*/" >> $1
    echo "UpgradeLog*.XML" >> $1
    echo "UpgradeLog*.htm" >> $1
    echo "ServiceFabricBackup/" >> $1
    echo "*.rptproj.bak" >> $1
    echo "" >> $1
    echo "# SQL Server files" >> $1
    echo "*.mdf" >> $1
    echo "*.ldf" >> $1
    echo "*.ndf" >> $1
    echo "" >> $1
    echo "# Business Intelligence projects" >> $1
    echo "*.rdl.data" >> $1
    echo "*.bim.layout" >> $1
    echo "*.bim_*.settings" >> $1
    echo "*.rptproj.rsuser" >> $1
    echo "*- [Bb]ackup.rdl" >> $1
    echo "*- [Bb]ackup ([0-9]).rdl" >> $1
    echo "*- [Bb]ackup ([0-9][0-9]).rdl" >> $1
    echo "" >> $1
    echo "# Microsoft Fakes" >> $1
    echo "FakesAssemblies/" >> $1
    echo "" >> $1
    echo "# GhostDoc plugin setting file" >> $1
    echo "*.GhostDoc.xml" >> $1
    echo "" >> $1
    echo "# Node.js Tools for Visual Studio" >> $1
    echo ".ntvs_analysis.dat" >> $1
    echo "node_modules/" >> $1
    echo "" >> $1
    echo "# Visual Studio 6 build log" >> $1
    echo "*.plg" >> $1
    echo "" >> $1
    echo "# Visual Studio 6 workspace options file" >> $1
    echo "*.opt" >> $1
    echo "" >> $1
    echo "# Visual Studio 6 auto-generated workspace file (contains which files were open etc.)" >> $1
    echo "*.vbw" >> $1
    echo "" >> $1
    echo "# Visual Studio LightSwitch build output" >> $1
    echo "**/*.HTMLClient/GeneratedArtifacts" >> $1
    echo "**/*.DesktopClient/GeneratedArtifacts" >> $1
    echo "**/*.DesktopClient/ModelManifest.xml" >> $1
    echo "**/*.Server/GeneratedArtifacts" >> $1
    echo "**/*.Server/ModelManifest.xml" >> $1
    echo "_Pvt_Extensions" >> $1
    echo "" >> $1
    echo "# Paket dependency manager" >> $1
    echo ".paket/paket.exe" >> $1
    echo "paket-files/" >> $1
    echo "" >> $1
    echo "# FAKE - F# Make" >> $1
    echo ".fake/" >> $1
    echo "" >> $1
    echo "# CodeRush personal settings" >> $1
    echo ".cr/personal" >> $1
    echo "" >> $1
    echo "# Python Tools for Visual Studio (PTVS)" >> $1
    echo "__pycache__/" >> $1
    echo "*.pyc" >> $1
    echo "" >> $1
    echo "# Cake - Uncomment if you are using it" >> $1
    echo "# tools/**" >> $1
    echo "# !tools/packages.config" >> $1
    echo "" >> $1
    echo "# Tabs Studio" >> $1
    echo "*.tss" >> $1
    echo "" >> $1
    echo "# Telerik's JustMock configuration file" >> $1
    echo "*.jmconfig" >> $1
    echo "" >> $1
    echo "# BizTalk build output" >> $1
    echo "*.btp.cs" >> $1
    echo "*.btm.cs" >> $1
    echo "*.odx.cs" >> $1
    echo "*.xsd.cs" >> $1
    echo "" >> $1
    echo "# OpenCover UI analysis results" >> $1
    echo "OpenCover/" >> $1
    echo "" >> $1
    echo "# Azure Stream Analytics local run output" >> $1
    echo "ASALocalRun/" >> $1
    echo "" >> $1
    echo "# MSBuild Binary and Structured Log" >> $1
    echo "*.binlog" >> $1
    echo "" >> $1
    echo "# NVidia Nsight GPU debugger configuration file" >> $1
    echo "*.nvuser" >> $1
    echo "" >> $1
    echo "# MFractors (Xamarin productivity tool) working folder" >> $1
    echo ".mfractor/" >> $1
    echo "" >> $1
    echo "# Local History for Visual Studio" >> $1
    echo ".localhistory/" >> $1
    echo "" >> $1
    echo "# BeatPulse healthcheck temp database" >> $1
    echo "healthchecksdb" >> $1
    echo "" >> $1
    echo "# Backup folder for Package Reference Convert tool in Visual Studio 2017" >> $1
    echo "MigrationBackup/" >> $1
    echo "" >> $1
    echo "# Ionide (cross platform F# VS Code tools) working folder" >> $1
    echo ".ionide/" >> $1
    echo "" >> $1
    echo "# Fody - auto-generated XML schema" >> $1
    echo "FodyWeavers.xsd" >> $1
    echo "" >> $1
    echo "# VS Code files for those working on multiple tools" >> $1
    echo ".vscode/*" >> $1
    echo "!.vscode/settings.json" >> $1
    echo "!.vscode/tasks.json" >> $1
    echo "!.vscode/launch.json" >> $1
    echo "!.vscode/extensions.json" >> $1
    echo "*.code-workspace" >> $1
    echo "" >> $1
    echo "# Local History for Visual Studio Code" >> $1
    echo ".history/" >> $1
    echo "" >> $1
    echo "# Windows Installer files from build outputs" >> $1
    echo "*.cab" >> $1
    echo "*.msi" >> $1
    echo "*.msix" >> $1
    echo "*.msm" >> $1
    echo "*.msp" >> $1
    echo "" >> $1
    echo "# JetBrains Rider" >> $1
    echo ".idea/" >> $1
    echo "*.sln.iml" >> $1
}

#..................................................................................
# Generate 'MSBuild' dir and files
#
genMsbuild()
{
    mkdir -p                                  "$1/src/MSBuild"
                                             >"$1/src/MSBuild/.runsettings"
    genMsbuild_runsettings                    "$1/src/MSBuild/.runsettings"
                                             >"$1/src/MSBuild/Common.props"
    genMsbuild_common_props                   "$1/src/MSBuild/Common.props"
                                             >"$1/src/MSBuild/Configurations.Platforms.props"
    genMsbuild_configurations_platforms_props "$1/src/MSBuild/Configurations.Platforms.props"
                                             >"$1/src/MSBuild/Directory.Build.props"
    genMsbuild_directory_build_props          "$1/src/MSBuild/Directory.Build.props"
                                             >"$1/src/MSBuild/Resources.props"
    genMsbuild_resources_props                "$1/src/MSBuild/Resources.props"
                                             >"$1/src/MSBuild/Settings.props"
    genMsbuild_settings_props                 "$1/src/MSBuild/Settings.props"
                                             >"$1/src/MSBuild/Targets.props"
    genMsbuild_targets_props                  "$1/src/MSBuild/Targets.props"
    mkdir -p                                  "$1/src/MSBuild/Packages"
                                             >"$1/src/MSBuild/Packages/.gitkeep"
    mkdir -p                                  "$1/src/MSBuild/Projects"
                                             >"$1/src/MSBuild/Projects/.gitkeep"
    mkdir -p                                  "$1/src/MSBuild/References"
                                             >"$1/src/MSBuild/References/.gitkeep"
}

#..................................................................................
# Generate '.runsettings' file content
#
genMsbuild_runsettings()
{
    echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" >> $1
    echo "<RunSettings>" >> $1
    echo "  <RunConfiguration>" >> $1
    echo "    <ResultsDirectory>.\artifacts\tests</ResultsDirectory>" >> $1
    echo "  </RunConfiguration>" >> $1
    echo "</RunSettings>" >> $1
}

#..................................................................................
# Generate 'Common.props' file content
#
genMsbuild_common_props()
{
    echo "<Project>" >> $1
    echo "  <Import Project=\"\$(CommonDir)\\AssemblyInfo.props\" />" >> $1
    echo "  <Import Project=\"\$(CommonDir)\\Targets.props\" />" >> $1
    echo "  <Import Project=\"\$(CommonDir)\\Packages.Ninject.props\" />" >> $1
    echo "  <ItemGroup Condition=\"\$(DefineConstants.Contains(NETFRAMEWORK))\">" >> $1
    echo "    <Reference Include=\"System\" />" >> $1
    echo "    <Reference Include=\"System.Core\" />" >> $1
    echo "    <Reference Include=\"Microsoft.CSharp\" />" >> $1
    echo "  </ItemGroup>" >> $1
    echo "</Project>" >> $1
}

#..................................................................................
# Generate 'Configurations.Platforms.props' file content
#
genMsbuild_configurations_platforms_props()
{
    echo "<Project>" >> $1
    echo "	<PropertyGroup>" >> $1
    echo "		<Configurations>Debug;Testing;Staging;Release</Configurations>" >> $1
    echo "	</PropertyGroup>" >> $1
    echo "	<PropertyGroup Condition=\" '\$(Platform)' == 'x86' \">" >> $1
    echo "		<PlatformTarget>x86</PlatformTarget>" >> $1
    echo "	</PropertyGroup>" >> $1
    echo "	<PropertyGroup Condition=\" '\$(Platform)' == 'Any CPU' \">" >> $1
    echo "		<PlatformTarget>Any CPU</PlatformTarget>" >> $1
    echo "	</PropertyGroup>" >> $1
    echo "	<PropertyGroup Condition=\" '\$(Configuration)' == 'Debug' \">" >> $1
    echo "		<DefineConstants>DEBUG;TRACE;DEVELOPMENT</DefineConstants>" >> $1
    echo "	</PropertyGroup>" >> $1
    echo "	<PropertyGroup Condition=\" '\$(Configuration)' == 'Testing' \">" >> $1
    echo "		<DefineConstants>TESTING;TRACE;TESTING</DefineConstants>" >> $1
    echo "	</PropertyGroup>" >> $1
    echo "	<PropertyGroup Condition=\" '\$(Configuration)' == 'Staging' \">" >> $1
    echo "		<DefineConstants>STAGING;TRACE;STAGING</DefineConstants>" >> $1
    echo "	</PropertyGroup>" >> $1
    echo "	<PropertyGroup Condition=\" '\$(Configuration)' == 'Release' \">" >> $1
    echo "		<DefineConstants>RELEASE;TRACE;PRODUCTION</DefineConstants>" >> $1
    echo "	</PropertyGroup>" >> $1
    echo "</Project>" >> $1
}

#..................................................................................
# Generate 'Directory.Build.props' file content
#
genMsbuild_directory_build_props()
{
    echo "<Project>" >> $1
    echo "" >> $1
    echo "  <!-- Directories -->" >> $1
    echo "  <PropertyGroup>" >> $1
    echo "    <SolutionDir>\$([MSBuild]::GetDirectoryNameOfFileAbove(\$(MSBuildThisFileDirectory), .root))</SolutionDir>" >> $1
    echo "    <ProgramFilesDir>\$([System.Environment]::ExpandEnvironmentVariables(\"%ProgramFiles%\"))</ProgramFilesDir>" >> $1
    echo "    <ReferenceAssembliesDir>\$(ProgramFilesDir)\Reference Assemblies\Microsoft\Framework\.NETFramework</ReferenceAssembliesDir>" >> $1
    echo "    <CommonDir>\$(SolutionDir)\modules\core\source\Common</CommonDir>" >> $1
    echo "    <ToolsDir>\$(SolutionDir)\modules\core\tools</ToolsDir>" >> $1
    echo "  </PropertyGroup>" >> $1
    echo "" >> $1
    echo "  <!-- Tools -->" >> $1
    echo "  <PropertyGroup>" >> $1
    echo "    <TransformExe>\$(ToolsDir)\Microsoft\TextTemplating\TextTransform.exe</TransformExe>" >> $1
    echo "  </PropertyGroup>" >> $1
    echo "" >> $1
    echo "  <!-- Build -->" >> $1
    echo "  <PropertyGroup>" >> $1
    echo "    <GenerateAssemblyInfo>false</GenerateAssemblyInfo>" >> $1
    echo "    <OutputPath>\$(SolutionDir)outputs\bin\\\$(Configuration)</OutputPath>" >> $1
    echo "    <BaseIntermediateOutputPath>\$(SolutionDir)outputs\obj\\\$(MSBuildProjectName)</BaseIntermediateOutputPath>" >> $1
    echo "  </PropertyGroup>" >> $1
    echo "" >> $1
    echo "  <!-- Constants -->" >> $1
    echo "  <PropertyGroup Condition=\"\$([System.Text.RegularExpressions.Regex]::IsMatch('\$(TargetFramework)', '^net\\d'))\">" >> $1
    echo "    <DefineConstants>NETFRAMEWORK</DefineConstants>" >> $1
    echo "  </PropertyGroup>" >> $1
    echo "  <PropertyGroup Condition=\"\$([System.Text.RegularExpressions.Regex]::IsMatch('\$(TargetFramework)', '^netstandard\\d'))\">" >> $1
    echo "    <DefineConstants>NETSTANDARD</DefineConstants>" >> $1
    echo "  </PropertyGroup>" >> $1
    echo "  <PropertyGroup Condition=\"\$([System.Text.RegularExpressions.Regex]::IsMatch('\$(TargetFramework)', '^netcoreapp\\d'))\">" >> $1
    echo "    <DefineConstants>NETCORE</DefineConstants>" >> $1
    echo "  </PropertyGroup>" >> $1
    echo "" >> $1
    echo "  <!-- Platforms -->" >> $1
    echo "  <Import Project=\"\$(CommonDir)\Configurations.Platforms.props\" />" >> $1
    echo "" >> $1
    echo "</Project>" >> $1
}

#..................................................................................
# Generate 'Resources.props' file content
#
genMsbuild_resources_props()
{
    echo "<Project>" >> $1
    echo "  <ItemGroup Condition=\"\$(DefineConstants.Contains(NETFRAMEWORK))\">" >> $1
    echo "    <Compile Update=\"Properties\\Resources.Designer.cs\">" >> $1
    echo "      <DesignTime>True</DesignTime>" >> $1
    echo "      <AutoGen>True</AutoGen>" >> $1
    echo "      <DependentUpon>Resources.resx</DependentUpon>" >> $1
    echo "    </Compile>" >> $1
    echo "    <EmbeddedResource Update=\"Properties\\Resources.resx\">" >> $1
    echo "      <Generator>ResXFileCodeGenerator</Generator>" >> $1
    echo "      <LastGenOutput>Resources.Designer.cs</LastGenOutput>" >> $1
    echo "    </EmbeddedResource>" >> $1
    echo "  </ItemGroup>" >> $1
    echo "" >> $1
    echo "  <!-- Se NÃO for NETFRAMEWORK -->" >> $1
    echo "  <ItemGroup Condition=\"!\$([System.Text.RegularExpressions.Regex]::IsMatch('\$(TargetFramework)', '^net\\d'))\">" >> $1
    echo "    <Compile Remove=\"Properties\\Resources.Designer.cs\" />" >> $1
    echo "    <EmbeddedResource Remove=\"Properties\\Resources.resx\" />" >> $1
    echo "  </ItemGroup>" >> $1
    echo "</Project>" >> $1
}

#..................................................................................
# Generate 'Settings.props' file content
#
genMsbuild_settings_props()
{
    echo "<Project>" >> $1
    echo "  <ItemGroup Condition=\"\$(DefineConstants.Contains(NETFRAMEWORK))\">" >> $1
    echo "    <Compile Update=\"Properties\\Settings.Designer.cs\">" >> $1
    echo "      <DesignTimeSharedInput>True</DesignTimeSharedInput>" >> $1
    echo "      <AutoGen>True</AutoGen>" >> $1
    echo "      <DependentUpon>Settings.settings</DependentUpon>" >> $1
    echo "    </Compile>" >> $1
    echo "    <None Update=\"Properties\\Settings.settings\">" >> $1
    echo "      <Generator>SettingsSingleFileGenerator</Generator>" >> $1
    echo "      <LastGenOutput>Settings.Designer.cs</LastGenOutput>" >> $1
    echo "    </None>" >> $1
    echo "  </ItemGroup>" >> $1
    echo "" >> $1
    echo "  <!-- Se NÃO for NETFRAMEWORK -->" >> $1
    echo "  <ItemGroup Condition=\"!\$([System.Text.RegularExpressions.Regex]::IsMatch('\$(TargetFramework)', '^net\\d'))\">" >> $1
    echo "    <!-- TODO -->" >> $1
    echo "  </ItemGroup>" >> $1
    echo "</Project>" >> $1
}

#..................................................................................
# Generate 'Targets.props' file content
#
genMsbuild_targets_props()
{
    echo "<Project>" >> $1
    echo "" >> $1
    echo "  <!-- Primeiramente ignora todos os targets (tgs) correspondentes -->" >> $1
    echo "  <ItemGroup>" >> $1
    echo "    <Compile Remove=\"**\*.tgs.*.cs\" />" >> $1
    echo "    <None Include=\"**\*.tgs.*.cs\" />" >> $1
    echo "  </ItemGroup>" >> $1
    echo "" >> $1
    echo "  <!-- Adiciona os targets .NET40 -->" >> $1
    echo "  <ItemGroup Condition=\"'\$(TargetFramework)' == 'net40'\">" >> $1
    echo "    <Compile Include=\"**\*.tgs.net40.cs\" />" >> $1
    echo "    <Compile Include=\"**\*.tgs.net40.Designer.cs\" />" >> $1
    echo "  </ItemGroup>" >> $1
    echo "" >> $1
    echo "  <!-- Adiciona os targets .NET461 -->" >> $1
    echo "  <ItemGroup Condition=\"'\$(TargetFramework)' == 'net461'\">" >> $1
    echo "    <Compile Include=\"**\*.tgs.net461.cs\" />" >> $1
    echo "    <Compile Include=\"**\*.tgs.net461.Designer.cs\" />" >> $1
    echo "  </ItemGroup>" >> $1
    echo "" >> $1
    echo "  <!-- Adiciona os targets .NET45+ (ou seja, todos os targets do NETFRAMEWORK a partir do .NET45) -->" >> $1
    echo "  <ItemGroup Condition=\"'\$(TargetFramework)' == 'net45' Or" >> $1
    echo "                        '\$(TargetFramework)' == 'net451' Or" >> $1
    echo "                        '\$(TargetFramework)' == 'net452' Or" >> $1
    echo "                        '\$(TargetFramework)' == 'net46' Or" >> $1
    echo "                        '\$(TargetFramework)' == 'net461' Or" >> $1
    echo "                        '\$(TargetFramework)' == 'net462' Or" >> $1
    echo "                        '\$(TargetFramework)' == 'net47' Or" >> $1
    echo "                        '\$(TargetFramework)' == 'net471' Or" >> $1
    echo "                        '\$(TargetFramework)' == 'net472'\">" >> $1
    echo "    <Compile Include=\"**\*.tgs.net45+.cs\" />" >> $1
    echo "    <Compile Include=\"**\*.tgs.net45+.Designer.cs\" />" >> $1
    echo "  </ItemGroup>" >> $1
    echo "" >> $1
    echo "  <!-- Adiciona os targets NETFRAMEWORK -->" >> $1
    echo "  <ItemGroup Condition=\"\$(DefineConstants.Contains(NETFRAMEWORK))\">" >> $1
    echo "    <Compile Include=\"**\*.tgs.netframework.cs\" />" >> $1
    echo "    <Compile Include=\"**\*.tgs.netframework.Designer.cs\" />" >> $1
    echo "  </ItemGroup>" >> $1
    echo "" >> $1
    echo "  <!-- Adiciona os targets NETSTANDARD -->" >> $1
    echo "  <ItemGroup Condition=\"\$(DefineConstants.Contains(NETSTANDARD))\">" >> $1
    echo "    <Compile Include=\"**\*.tgs.netstandard.cs\" />" >> $1
    echo "  </ItemGroup>" >> $1
    echo "" >> $1
    echo "  <!-- Adiciona os targets NETCOREAPP -->" >> $1
    echo "  <ItemGroup Condition=\"\$(DefineConstants.Contains(NETCOREAPP))\">" >> $1
    echo "    <Compile Include=\"**\*.tgs.netcoreapp.cs\" />" >> $1
    echo "  </ItemGroup>" >> $1
    echo "</Project>" >> $1
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ TODO
#/
#/ slb-net-shdlib.sh [-v] [/?]
#/   -v         Shows the script version
#/   /?         Shows this help