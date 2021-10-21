#!/bin/bash
#slb-git-scf-net-smcore.sh Version 0.1
#..................................................................................
# Description:
#   TODO.
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#..................................................................................

#..................................................................................
# The main entry point for the script
#
main()
{
    # shellcheck source=/dev/null
    {
    . slb-helper.sh && return 0
    . slb-argadd.sh "$@"
    }

    # shellcheck disable=SC2154,SC2086
    if unvalued "d" $f >/dev/null; then d=$PWD; fi

    # shellcheck disable=SC2154,SC2086
    if unvalued "n" $n; then return 1; fi

    # generate structure
    scaffold "$d/$n"
}

#..................................................................................
# Generate SharedLib structure
#
scaffold()
{
    root=$1
    genGit "$root"
    genMsbuild "$root"
    genReadme "$root"
    slb-git-scf-net-licnse.sh -d:"$root"
}

#..................................................................................
# Generate 'Git' dir and files
#
genGit()
{
    mkdir -p             "$1"
    mkdir -p             "$1/src"
    mkdir -p             "$1/src/Git"
                       :>"$1/src/Git/.gitattributes"
    genGit_gitattributes "$1/src/Git/.gitattributes"
                       :>"$1/src/Git/.gitignore"
    genGit_gitignore     "$1/src/Git/.gitignore"
}

#..................................................................................
# Generate '.gitattributes' file content
#
genGit_gitattributes()
{
    {
        echo "###############################################################################"
        echo "# Set default behavior to automatically normalize line endings."
        echo "###############################################################################"
        echo "* text=auto"
        echo ""
        echo "###############################################################################"
        echo "# Set default behavior for command prompt diff."
        echo "#"
        echo "# This is need for earlier builds of msysgit that does not have it on by"
        echo "# default for csharp files."
        echo "# Note: This is only used by command line"
        echo "###############################################################################"
        echo "#*.cs     diff=csharp"
        echo ""
        echo "###############################################################################"
        echo "# Set the merge driver for project and solution files"
        echo "#"
        echo "# Merging from the command prompt will add diff markers to the files if there"
        echo "# are conflicts (Merging from VS is not affected by the settings below, in VS"
        echo "# the diff markers are never inserted). Diff markers may cause the following"
        echo "# file extensions to fail to load in VS. An alternative would be to treat"
        echo "# these files as binary and thus will always conflict and require user"
        echo "# intervention with every merge. To do so, just uncomment the entries below"
        echo "###############################################################################"
        echo "#*.sln       merge=binary"
        echo "#*.csproj    merge=binary"
        echo "#*.vbproj    merge=binary"
        echo "#*.vcxproj   merge=binary"
        echo "#*.vcproj    merge=binary"
        echo "#*.dbproj    merge=binary"
        echo "#*.fsproj    merge=binary"
        echo "#*.lsproj    merge=binary"
        echo "#*.wixproj   merge=binary"
        echo "#*.modelproj merge=binary"
        echo "#*.sqlproj   merge=binary"
        echo "#*.wwaproj   merge=binary"
        echo ""
        echo "###############################################################################"
        echo "# behavior for image files"
        echo "#"
        echo "# image files are treated as binary by default."
        echo "###############################################################################"
        echo "#*.jpg   binary"
        echo "#*.png   binary"
        echo "#*.gif   binary"
        echo ""
        echo "###############################################################################"
        echo "# diff behavior for common document formats"
        echo "#"
        echo "# Convert binary document formats to text before diffing them. This feature"
        echo "# is only available from the command line. Turn it on by uncommenting the"
        echo "# entries below."
        echo "###############################################################################"
        echo "#*.doc   diff=astextplain"
        echo "#*.DOC   diff=astextplain"
        echo "#*.docx  diff=astextplain"
        echo "#*.DOCX  diff=astextplain"
        echo "#*.dot   diff=astextplain"
        echo "#*.DOT   diff=astextplain"
        echo "#*.pdf   diff=astextplain"
        echo "#*.PDF   diff=astextplain"
        echo "#*.rtf   diff=astextplain"
        echo "#*.RTF   diff=astextplain"
    } >> "$1"
}

#..................................................................................
# Generate '.gitignore' file content
#
genGit_gitignore()
{
    {
        echo "## Ignore Visual Studio temporary files, build results, and"
        echo "## files generated by popular Visual Studio add-ons."
        echo "##"
        echo "## Get latest from https://github.com/github/gitignore/blob/master/VisualStudio.gitignore"
        echo ""
        echo "# User-specific files"
        echo "*.rsuser"
        echo "*.suo"
        echo "*.user"
        echo "*.userosscache"
        echo "*.sln.docstates"
        echo ""
        echo "# User-specific files (MonoDevelop/Xamarin Studio)"
        echo "*.userprefs"
        echo ""
        echo "# Mono auto generated files"
        echo "mono_crash.*"
        echo ""
        echo "# Build results"
        echo "[Dd]ebug/"
        echo "[Dd]ebugPublic/"
        echo "[Rr]elease/"
        echo "[Rr]eleases/"
        echo "x64/"
        echo "x86/"
        echo "[Ww][Ii][Nn]32/"
        echo "[Aa][Rr][Mm]/"
        echo "[Aa][Rr][Mm]64/"
        echo "bld/"
        echo "[Bb]in/"
        echo "[Oo]bj/"
        echo "[Ll]og/"
        echo "[Ll]ogs/"
        echo ""
        echo "# Visual Studio 2015/2017 cache/options directory"
        echo ".vs/"
        echo "# Uncomment if you have tasks that create the project's static files in wwwroot"
        echo "#wwwroot/"
        echo ""
        echo "# Visual Studio 2017 auto generated files"
        echo "Generated\ Files/"
        echo ""
        echo "# MSTest test Results"
        echo "[Tt]est[Rr]esult*/"
        echo "[Bb]uild[Ll]og.*"
        echo ""
        echo "# NUnit"
        echo "*.VisualState.xml"
        echo "TestResult.xml"
        echo "nunit-*.xml"
        echo ""
        echo "# Build Results of an ATL Project"
        echo "[Dd]ebugPS/"
        echo "[Rr]eleasePS/"
        echo "dlldata.c"
        echo ""
        echo "# Benchmark Results"
        echo "BenchmarkDotNet.Artifacts/"
        echo ""
        echo "# .NET Core"
        echo "project.lock.json"
        echo "project.fragment.lock.json"
        echo "artifacts/"
        echo ""
        echo "# ASP.NET Scaffolding"
        echo "ScaffoldingReadMe.txt"
        echo ""
        echo "# StyleCop"
        echo "StyleCopReport.xml"
        echo ""
        echo "# Files built by Visual Studio"
        echo "*_i.c"
        echo "*_p.c"
        echo "*_h.h"
        echo "*.ilk"
        echo "*.meta"
        echo "*.obj"
        echo "*.iobj"
        echo "*.pch"
        echo "*.pdb"
        echo "*.ipdb"
        echo "*.pgc"
        echo "*.pgd"
        echo "*.rsp"
        echo "*.sbr"
        echo "*.tlb"
        echo "*.tli"
        echo "*.tlh"
        echo "*.tmp"
        echo "*.tmp_proj"
        echo "*_wpftmp.csproj"
        echo "*.log"
        echo "*.tlog"
        echo "*.vspscc"
        echo "*.vssscc"
        echo ".builds"
        echo "*.pidb"
        echo "*.svclog"
        echo "*.scc"
        echo ""
        echo "# Chutzpah Test files"
        echo "_Chutzpah*"
        echo ""
        echo "# Visual C++ cache files"
        echo "ipch/"
        echo "*.aps"
        echo "*.ncb"
        echo "*.opendb"
        echo "*.opensdf"
        echo "*.sdf"
        echo "*.cachefile"
        echo "*.VC.db"
        echo "*.VC.VC.opendb"
        echo ""
        echo "# Visual Studio profiler"
        echo "*.psess"
        echo "*.vsp"
        echo "*.vspx"
        echo "*.sap"
        echo ""
        echo "# Visual Studio Trace Files"
        echo "*.e2e"
        echo ""
        echo "# TFS 2012 Local Workspace"
        echo "\$tf/"
        echo ""
        echo "# Guidance Automation Toolkit"
        echo "*.gpState"
        echo ""
        echo "# ReSharper is a .NET coding add-in"
        echo "_ReSharper*/"
        echo "*.[Rr]e[Ss]harper"
        echo "*.DotSettings.user"
        echo ""
        echo "# TeamCity is a build add-in"
        echo "_TeamCity*"
        echo ""
        echo "# DotCover is a Code Coverage Tool"
        echo "*.dotCover"
        echo ""
        echo "# AxoCover is a Code Coverage Tool"
        echo ".axoCover/*"
        echo "!.axoCover/settings.json"
        echo ""
        echo "# Coverlet is a free, cross platform Code Coverage Tool"
        echo "coverage*.json"
        echo "coverage*.xml"
        echo "coverage*.info"
        echo ""
        echo "# Visual Studio code coverage results"
        echo "*.coverage"
        echo "*.coveragexml"
        echo ""
        echo "# NCrunch"
        echo "_NCrunch_*"
        echo ".*crunch*.local.xml"
        echo "nCrunchTemp_*"
        echo ""
        echo "# MightyMoose"
        echo "*.mm.*"
        echo "AutoTest.Net/"
        echo ""
        echo "# Web workbench (sass)"
        echo ".sass-cache/"
        echo ""
        echo "# Installshield output folder"
        echo "[Ee]xpress/"
        echo ""
        echo "# DocProject is a documentation generator add-in"
        echo "DocProject/buildhelp/"
        echo "DocProject/Help/*.HxT"
        echo "DocProject/Help/*.HxC"
        echo "DocProject/Help/*.hhc"
        echo "DocProject/Help/*.hhk"
        echo "DocProject/Help/*.hhp"
        echo "DocProject/Help/Html2"
        echo "DocProject/Help/html"
        echo ""
        echo "# Click-Once directory"
        echo "publish/"
        echo ""
        echo "# Publish Web Output"
        echo "*.[Pp]ublish.xml"
        echo "*.azurePubxml"
        echo "# Note: Comment the next line if you want to checkin your web deploy settings,"
        echo "# but database connection strings (with potential passwords) will be unencrypted"
        echo "*.pubxml"
        echo "*.publishproj"
        echo ""
        echo "# Microsoft Azure Web App publish settings. Comment the next line if you want to"
        echo "# checkin your Azure Web App publish settings, but sensitive information contained"
        echo "# in these scripts will be unencrypted"
        echo "PublishScripts/"
        echo ""
        echo "# NuGet Packages"
        echo "*.nupkg"
        echo "# NuGet Symbol Packages"
        echo "*.snupkg"
        echo "# The packages folder can be ignored because of Package Restore"
        echo "**/[Pp]ackages/*"
        echo "# except build/, which is used as an MSBuild target."
        echo "!**/[Pp]ackages/build/"
        echo "# Uncomment if necessary however generally it will be regenerated when needed"
        echo "#!**/[Pp]ackages/repositories.config"
        echo "# NuGet v3's project.json files produces more ignorable files"
        echo "*.nuget.props"
        echo "*.nuget.targets"
        echo ""
        echo "# Nuget personal access tokens and Credentials"
        echo "nuget.config"
        echo ""
        echo "# Microsoft Azure Build Output"
        echo "csx/"
        echo "*.build.csdef"
        echo ""
        echo "# Microsoft Azure Emulator"
        echo "ecf/"
        echo "rcf/"
        echo ""
        echo "# Windows Store app package directories and files"
        echo "AppPackages/"
        echo "BundleArtifacts/"
        echo "Package.StoreAssociation.xml"
        echo "_pkginfo.txt"
        echo "*.appx"
        echo "*.appxbundle"
        echo "*.appxupload"
        echo ""
        echo "# Visual Studio cache files"
        echo "# files ending in .cache can be ignored"
        echo "*.[Cc]ache"
        echo "# but keep track of directories ending in .cache"
        echo "!?*.[Cc]ache/"
        echo ""
        echo "# Others"
        echo "ClientBin/"
        echo "~$*"
        echo "*~"
        echo "*.dbmdl"
        echo "*.dbproj.schemaview"
        echo "*.jfm"
        echo "*.pfx"
        echo "*.publishsettings"
        echo "orleans.codegen.cs"
        echo ""
        echo "# Including strong name files can present a security risk"
        echo "# (https://github.com/github/gitignore/pull/2483#issue-259490424)"
        echo "#*.snk"
        echo ""
        echo "# Since there are multiple workflows, uncomment next line to ignore bower_components"
        echo "# (https://github.com/github/gitignore/pull/1529#issuecomment-104372622)"
        echo "#bower_components/"
        echo ""
        echo "# RIA/Silverlight projects"
        echo "Generated_Code/"
        echo ""
        echo "# Backup & report files from converting an old project file"
        echo "# to a newer Visual Studio version. Backup files are not needed,"
        echo "# because we have git ;-)"
        echo "_UpgradeReport_Files/"
        echo "Backup*/"
        echo "UpgradeLog*.XML"
        echo "UpgradeLog*.htm"
        echo "ServiceFabricBackup/"
        echo "*.rptproj.bak"
        echo ""
        echo "# SQL Server files"
        echo "*.mdf"
        echo "*.ldf"
        echo "*.ndf"
        echo ""
        echo "# Business Intelligence projects"
        echo "*.rdl.data"
        echo "*.bim.layout"
        echo "*.bim_*.settings"
        echo "*.rptproj.rsuser"
        echo "*- [Bb]ackup.rdl"
        echo "*- [Bb]ackup ([0-9]).rdl"
        echo "*- [Bb]ackup ([0-9][0-9]).rdl"
        echo ""
        echo "# Microsoft Fakes"
        echo "FakesAssemblies/"
        echo ""
        echo "# GhostDoc plugin setting file"
        echo "*.GhostDoc.xml"
        echo ""
        echo "# Node.js Tools for Visual Studio"
        echo ".ntvs_analysis.dat"
        echo "node_modules/"
        echo ""
        echo "# Visual Studio 6 build log"
        echo "*.plg"
        echo ""
        echo "# Visual Studio 6 workspace options file"
        echo "*.opt"
        echo ""
        echo "# Visual Studio 6 auto-generated workspace file (contains which files were open etc.)"
        echo "*.vbw"
        echo ""
        echo "# Visual Studio LightSwitch build output"
        echo "**/*.HTMLClient/GeneratedArtifacts"
        echo "**/*.DesktopClient/GeneratedArtifacts"
        echo "**/*.DesktopClient/ModelManifest.xml"
        echo "**/*.Server/GeneratedArtifacts"
        echo "**/*.Server/ModelManifest.xml"
        echo "_Pvt_Extensions"
        echo ""
        echo "# Paket dependency manager"
        echo ".paket/paket.exe"
        echo "paket-files/"
        echo ""
        echo "# FAKE - F# Make"
        echo ".fake/"
        echo ""
        echo "# CodeRush personal settings"
        echo ".cr/personal"
        echo ""
        echo "# Python Tools for Visual Studio (PTVS)"
        echo "__pycache__/"
        echo "*.pyc"
        echo ""
        echo "# Cake - Uncomment if you are using it"
        echo "# tools/**"
        echo "# !tools/packages.config"
        echo ""
        echo "# Tabs Studio"
        echo "*.tss"
        echo ""
        echo "# Telerik's JustMock configuration file"
        echo "*.jmconfig"
        echo ""
        echo "# BizTalk build output"
        echo "*.btp.cs"
        echo "*.btm.cs"
        echo "*.odx.cs"
        echo "*.xsd.cs"
        echo ""
        echo "# OpenCover UI analysis results"
        echo "OpenCover/"
        echo ""
        echo "# Azure Stream Analytics local run output"
        echo "ASALocalRun/"
        echo ""
        echo "# MSBuild Binary and Structured Log"
        echo "*.binlog"
        echo ""
        echo "# NVidia Nsight GPU debugger configuration file"
        echo "*.nvuser"
        echo ""
        echo "# MFractors (Xamarin productivity tool) working folder"
        echo ".mfractor/"
        echo ""
        echo "# Local History for Visual Studio"
        echo ".localhistory/"
        echo ""
        echo "# BeatPulse healthcheck temp database"
        echo "healthchecksdb"
        echo ""
        echo "# Backup folder for Package Reference Convert tool in Visual Studio 2017"
        echo "MigrationBackup/"
        echo ""
        echo "# Ionide (cross platform F# VS Code tools) working folder"
        echo ".ionide/"
        echo ""
        echo "# Fody - auto-generated XML schema"
        echo "FodyWeavers.xsd"
        echo ""
        echo "# VS Code files for those working on multiple tools"
        echo ".vscode/*"
        echo "!.vscode/settings.json"
        echo "!.vscode/tasks.json"
        echo "!.vscode/launch.json"
        echo "!.vscode/extensions.json"
        echo "*.code-workspace"
        echo ""
        echo "# Local History for Visual Studio Code"
        echo ".history/"
        echo ""
        echo "# Windows Installer files from build outputs"
        echo "*.cab"
        echo "*.msi"
        echo "*.msix"
        echo "*.msm"
        echo "*.msp"
        echo ""
        echo "# JetBrains Rider"
        echo ".idea/"
        echo "*.sln.iml"
    } >> "$1"
}

#..................................................................................
# Generate 'MSBuild' dir and files
#
genMsbuild()
{
    mkdir -p                                  "$1/src/MSBuild"
                                            :>"$1/src/MSBuild/.runsettings"
    genMsbuild_runsettings                    "$1/src/MSBuild/.runsettings"
                                            :>"$1/src/MSBuild/Common.props"
    genMsbuild_common_props                   "$1/src/MSBuild/Common.props"
                                            :>"$1/src/MSBuild/Configurations.Platforms.props"
    genMsbuild_configurations_platforms_props "$1/src/MSBuild/Configurations.Platforms.props"
                                            :>"$1/src/MSBuild/Directory.Build.props"
    genMsbuild_directory_build_props          "$1/src/MSBuild/Directory.Build.props"
                                            :>"$1/src/MSBuild/Resources.props"
    genMsbuild_resources_props                "$1/src/MSBuild/Resources.props"
                                            :>"$1/src/MSBuild/Settings.props"
    genMsbuild_settings_props                 "$1/src/MSBuild/Settings.props"
                                            :>"$1/src/MSBuild/Targets.props"
    genMsbuild_targets_props                  "$1/src/MSBuild/Targets.props"
    mkdir -p                                  "$1/src/MSBuild/Packages"
                                            :>"$1/src/MSBuild/Packages/.gitkeep"
    mkdir -p                                  "$1/src/MSBuild/Projects"
                                            :>"$1/src/MSBuild/Projects/.gitkeep"
    mkdir -p                                  "$1/src/MSBuild/References"
                                            :>"$1/src/MSBuild/References/.gitkeep"
}

#..................................................................................
# Generate '.runsettings' file content
#
genMsbuild_runsettings()
{
    {
        echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        echo "<RunSettings>"
        echo "  <RunConfiguration>"
        echo "    <ResultsDirectory>.\\artifacts\\tests</ResultsDirectory>"
        echo "  </RunConfiguration>"
        echo "</RunSettings>"
    } >> "$1"
}

#..................................................................................
# Generate 'Common.props' file content
#
genMsbuild_common_props()
{
    {
        echo "<Project>"
        echo "  <Import Project=\"\$(MSBuildDir)\\AssemblyInfo.props\" />"
        echo "  <Import Project=\"\$(MSBuildDir)\\Targets.props\" />"
        echo "  <Import Project=\"\$(MSBuildDir)\\Packages.Ninject.props\" />"
        echo "  <ItemGroup Condition=\"\$(DefineConstants.Contains(NETFRAMEWORK))\">"
        echo "    <Reference Include=\"System\" />"
        echo "    <Reference Include=\"System.Core\" />"
        echo "    <Reference Include=\"Microsoft.CSharp\" />"
        echo "  </ItemGroup>"
        echo "</Project>"
    } >> "$1"
}

#..................................................................................
# Generate 'Configurations.Platforms.props' file content
#
genMsbuild_configurations_platforms_props()
{
    {
        echo "<Project>"
        echo "	<PropertyGroup>"
        echo "		<Configurations>Debug;Testing;Staging;Release</Configurations>"
        echo "	</PropertyGroup>"
        echo "	<PropertyGroup Condition=\" '\$(Platform)' == 'x86' \">"
        echo "		<PlatformTarget>x86</PlatformTarget>"
        echo "	</PropertyGroup>"
        echo "	<PropertyGroup Condition=\" '\$(Platform)' == 'Any CPU' \">"
        echo "		<PlatformTarget>Any CPU</PlatformTarget>"
        echo "	</PropertyGroup>"
        echo "	<PropertyGroup Condition=\" '\$(Configuration)' == 'Debug' \">"
        echo "		<DefineConstants>DEBUG;TRACE;DEVELOPMENT</DefineConstants>"
        echo "	</PropertyGroup>"
        echo "	<PropertyGroup Condition=\" '\$(Configuration)' == 'Testing' \">"
        echo "		<DefineConstants>TESTING;TRACE;TESTING</DefineConstants>"
        echo "	</PropertyGroup>"
        echo "	<PropertyGroup Condition=\" '\$(Configuration)' == 'Staging' \">"
        echo "		<DefineConstants>STAGING;TRACE;STAGING</DefineConstants>"
        echo "	</PropertyGroup>"
        echo "	<PropertyGroup Condition=\" '\$(Configuration)' == 'Release' \">"
        echo "		<DefineConstants>RELEASE;TRACE;PRODUCTION</DefineConstants>"
        echo "	</PropertyGroup>"
        echo "</Project>"
    } >> "$1"
}

#..................................................................................
# Generate 'Directory.Build.props' file content
#
genMsbuild_directory_build_props()
{
    {
        echo "<Project>"
        echo ""
        echo "  <!-- Directories -->"
        echo "  <PropertyGroup>"
        echo "    <SolutionDir>\$([MSBuild]::GetDirectoryNameOfFileAbove(\$(MSBuildThisFileDirectory), .root))</SolutionDir>"
        echo "    <ProgramFilesDir>\$([System.Environment]::ExpandEnvironmentVariables(\"%ProgramFiles%\"))</ProgramFilesDir>"
        echo "    <ReferenceAssembliesDir>\$(ProgramFilesDir)\\Reference Assemblies\\Microsoft\\Framework\\.NETFramework</ReferenceAssembliesDir>"
        echo "    <MSBuildDir>\$(SolutionDir)\modules\\$n\src\MSBuild</MSBuildDir>"
        echo "    <ToolsDir>\$(SolutionDir)\\modules\\$n\tools</ToolsDir>"
        echo "  </PropertyGroup>"
        echo ""
        echo "  <!-- Tools -->"
        echo "  <PropertyGroup>"
        echo "    <TransformExe>\$(ToolsDir)\\Microsoft\\TextTemplating\\TextTransform.exe</TransformExe>"
        echo "  </PropertyGroup>"
        echo ""
        echo "  <!-- Build -->"
        echo "  <PropertyGroup>"
        echo "    <GenerateAssemblyInfo>false</GenerateAssemblyInfo>"
        echo "    <OutputPath>\$(SolutionDir)artifacts\\bin\\\$(Configuration)</OutputPath>"
        echo "    <BaseIntermediateOutputPath>\$(SolutionDir)artifacts\\obj\\\$(MSBuildProjectName)</BaseIntermediateOutputPath>"
        echo "  </PropertyGroup>"
        echo ""
        echo "  <!-- Constants -->"
        echo "  <PropertyGroup Condition=\"\$([System.Text.RegularExpressions.Regex]::IsMatch('\$(TargetFramework)', '^net\\d'))\">"
        echo "    <DefineConstants>NETFRAMEWORK</DefineConstants>"
        echo "  </PropertyGroup>"
        echo "  <PropertyGroup Condition=\"\$([System.Text.RegularExpressions.Regex]::IsMatch('\$(TargetFramework)', '^netstandard\\d'))\">"
        echo "    <DefineConstants>NETSTANDARD</DefineConstants>"
        echo "  </PropertyGroup>"
        echo "  <PropertyGroup Condition=\"\$([System.Text.RegularExpressions.Regex]::IsMatch('\$(TargetFramework)', '^netcoreapp\\d'))\">"
        echo "    <DefineConstants>NETCORE</DefineConstants>"
        echo "  </PropertyGroup>"
        echo ""
        echo "  <!-- Platforms -->"
        echo "  <Import Project=\"\$(MSBuildDir)\\Configurations.Platforms.props\" />"
        echo ""
        echo "</Project>"
    } >> "$1"
}

#..................................................................................
# Generate 'Resources.props' file content
#
genMsbuild_resources_props()
{
    {
        echo "<Project>"
        echo "  <ItemGroup Condition=\"\$(DefineConstants.Contains(NETFRAMEWORK))\">"
        echo "    <Compile Update=\"Properties\\Resources.Designer.cs\">"
        echo "      <DesignTime>True</DesignTime>"
        echo "      <AutoGen>True</AutoGen>"
        echo "      <DependentUpon>Resources.resx</DependentUpon>"
        echo "    </Compile>"
        echo "    <EmbeddedResource Update=\"Properties\\Resources.resx\">"
        echo "      <Generator>ResXFileCodeGenerator</Generator>"
        echo "      <LastGenOutput>Resources.Designer.cs</LastGenOutput>"
        echo "    </EmbeddedResource>"
        echo "  </ItemGroup>"
        echo ""
        echo "  <!-- Se NÃO for NETFRAMEWORK -->"
        echo "  <ItemGroup Condition=\"!\$([System.Text.RegularExpressions.Regex]::IsMatch('\$(TargetFramework)', '^net\\d'))\">"
        echo "    <Compile Remove=\"Properties\\Resources.Designer.cs\" />"
        echo "    <EmbeddedResource Remove=\"Properties\\Resources.resx\" />"
        echo "  </ItemGroup>"
        echo "</Project>"
    } >> "$1"
}

#..................................................................................
# Generate 'Settings.props' file content
#
genMsbuild_settings_props()
{
    {
        echo "<Project>"
        echo "  <ItemGroup Condition=\"\$(DefineConstants.Contains(NETFRAMEWORK))\">"
        echo "    <Compile Update=\"Properties\\Settings.Designer.cs\">"
        echo "      <DesignTimeSharedInput>True</DesignTimeSharedInput>"
        echo "      <AutoGen>True</AutoGen>"
        echo "      <DependentUpon>Settings.settings</DependentUpon>"
        echo "    </Compile>"
        echo "    <None Update=\"Properties\\Settings.settings\">"
        echo "      <Generator>SettingsSingleFileGenerator</Generator>"
        echo "      <LastGenOutput>Settings.Designer.cs</LastGenOutput>"
        echo "    </None>"
        echo "  </ItemGroup>"
        echo ""
        echo "  <!-- Se NÃO for NETFRAMEWORK -->"
        echo "  <ItemGroup Condition=\"!\$([System.Text.RegularExpressions.Regex]::IsMatch('\$(TargetFramework)', '^net\\d'))\">"
        echo "    <!-- TODO -->"
        echo "  </ItemGroup>"
        echo "</Project>"
    } >> "$1"
}

#..................................................................................
# Generate 'Targets.props' file content
#
genMsbuild_targets_props()
{
    {
        echo "<Project>"
        echo ""
        echo "  <!-- Primeiramente ignora todos os targets (tgs) correspondentes -->"
        echo "  <ItemGroup>"
        echo "    <Compile Remove=\"**\*.tgs.*.cs\" />"
        echo "    <None Include=\"**\*.tgs.*.cs\" />"
        echo "  </ItemGroup>"
        echo ""
        echo "  <!-- Adiciona os targets .NET40 -->"
        echo "  <ItemGroup Condition=\"'\$(TargetFramework)' == 'net40'\">"
        echo "    <Compile Include=\"**\*.tgs.net40.cs\" />"
        echo "    <Compile Include=\"**\*.tgs.net40.Designer.cs\" />"
        echo "  </ItemGroup>"
        echo ""
        echo "  <!-- Adiciona os targets .NET461 -->"
        echo "  <ItemGroup Condition=\"'\$(TargetFramework)' == 'net461'\">"
        echo "    <Compile Include=\"**\*.tgs.net461.cs\" />"
        echo "    <Compile Include=\"**\*.tgs.net461.Designer.cs\" />"
        echo "  </ItemGroup>"
        echo ""
        echo "  <!-- Adiciona os targets .NET45+ (ou seja, todos os targets do NETFRAMEWORK a partir do .NET45) -->"
        echo "  <ItemGroup Condition=\"'\$(TargetFramework)' == 'net45' Or"
        echo "                        '\$(TargetFramework)' == 'net451' Or"
        echo "                        '\$(TargetFramework)' == 'net452' Or"
        echo "                        '\$(TargetFramework)' == 'net46' Or"
        echo "                        '\$(TargetFramework)' == 'net461' Or"
        echo "                        '\$(TargetFramework)' == 'net462' Or"
        echo "                        '\$(TargetFramework)' == 'net47' Or"
        echo "                        '\$(TargetFramework)' == 'net471' Or"
        echo "                        '\$(TargetFramework)' == 'net472'\">"
        echo "    <Compile Include=\"**\*.tgs.net45+.cs\" />"
        echo "    <Compile Include=\"**\*.tgs.net45+.Designer.cs\" />"
        echo "  </ItemGroup>"
        echo ""
        echo "  <!-- Adiciona os targets NETFRAMEWORK -->"
        echo "  <ItemGroup Condition=\"\$(DefineConstants.Contains(NETFRAMEWORK))\">"
        echo "    <Compile Include=\"**\*.tgs.netframework.cs\" />"
        echo "    <Compile Include=\"**\*.tgs.netframework.Designer.cs\" />"
        echo "  </ItemGroup>"
        echo ""
        echo "  <!-- Adiciona os targets NETSTANDARD -->"
        echo "  <ItemGroup Condition=\"\$(DefineConstants.Contains(NETSTANDARD))\">"
        echo "    <Compile Include=\"**\*.tgs.netstandard.cs\" />"
        echo "  </ItemGroup>"
        echo ""
        echo "  <!-- Adiciona os targets NETCOREAPP -->"
        echo "  <ItemGroup Condition=\"\$(DefineConstants.Contains(NETCOREAPP))\">"
        echo "    <Compile Include=\"**\*.tgs.netcoreapp.cs\" />"
        echo "  </ItemGroup>"
        echo "</Project>"
    } >> "$1"
}

#..................................................................................
# Generate 'README' file content
#
genReadme()
{
    f="$1/README.md"
    :>"$f"

    {
        echo "Submodule core structure for .NET"
        echo ""
        echo "/"
        echo "  src/                  - Source code"
        echo "  LICENSE               - License"
        echo "  README.md             - Readme"
        echo ""
    } >> "$f"
}

#..................................................................................
# Check if variable is empty
#
unvalued()
{
    # if variable is unset or set to the empty string
    if [ -z ${2+x} ]; then
        echo "-${1} is empty"
        return 0 # true
    fi

    # if variable is set to it´s own name
    if [ "${2}" == "-${1}" ]; then
        echo "-${1} is empty"
        return 0 # true
    fi

    return 1 # false
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/  Create submodule core structure for .NET
#/
#/ slb-git-scf-net-smcore.sh <-d:> <-n:> [-v] [/?]
#/   -d         Directory
#/   -n         Name
#/   -v         Shows the script version
#/   /?         Shows this help