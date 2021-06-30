using System;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using UnityEditor;
using Application = UnityEngine.Application;
using BuildResult = UnityEditor.Build.Reporting.BuildResult;

public class Build
{
    static readonly string ProjectPath = Path.GetFullPath(Path.Combine(Application.dataPath, ".."));

    static readonly string apkPath = Path.Combine(ProjectPath, "Builds/" + Application.productName + ".apk");

    static readonly string androidExportPath = Path.GetFullPath(Path.Combine(ProjectPath, "../../android/unityLibrary"));
    static readonly string iosExportPath = Path.GetFullPath(Path.Combine(ProjectPath, "../../ios/UnityLibrary"));


    public static void DoBuildAndroid()
    {
        BuildAndroid(Path.Combine(apkPath, "unityLibrary"));

        // Copy over resources from the launcher module that are used by the library
        Copy(Path.Combine(apkPath + "/launcher/src/main/res"), Path.Combine(androidExportPath, "src/main/res"));
    }

    private static void BuildAndroid(String buildPath)
    {
        if (Directory.Exists(apkPath))
            Directory.Delete(apkPath, true);

        if (Directory.Exists(androidExportPath))
            Directory.Delete(androidExportPath, true);

        EditorUserBuildSettings.androidBuildSystem = AndroidBuildSystem.Gradle;

        var options = BuildOptions.AllowDebugging;
        EditorUserBuildSettings.exportAsGoogleAndroidProject = true;
        var report = BuildPipeline.BuildPlayer(
            GetEnabledScenes(),
            apkPath,
            BuildTarget.Android,
            options
        );

        if (report.summary.result != BuildResult.Succeeded)
            throw new Exception("Build failed");

        Copy(buildPath, androidExportPath);

        // Modify build.gradle
        var build_file = Path.Combine(androidExportPath, "build.gradle");
        var build_text = File.ReadAllText(build_file);
        build_text = build_text.Replace("com.android.application", "com.android.library");
        build_text = build_text.Replace("bundle {", "splits {");
        build_text = build_text.Replace("enableSplit = false", "enable false");
        build_text = build_text.Replace("enableSplit = true", "enable true");
        build_text = build_text.Replace("implementation fileTree(dir: 'libs', include: ['*.jar'])", "implementation(name: 'unity-classes', ext:'jar')");
        build_text = Regex.Replace(build_text, @"\n.*applicationId '.+'.*\n", "\n");
        File.WriteAllText(build_file, build_text);

        // Modify AndroidManifest.xml
        var manifest_file = Path.Combine(androidExportPath, "src/main/AndroidManifest.xml");
        var manifest_text = File.ReadAllText(manifest_file);
        manifest_text = Regex.Replace(manifest_text, @"<application .*>", "<application>");
        Regex regex = new Regex(@"<activity.*>(\s|\S)+?</activity>", RegexOptions.Multiline);
        manifest_text = regex.Replace(manifest_text, "");
        File.WriteAllText(manifest_file, manifest_text);


       SetupAndroidProject();

    }

    public static void DoBuildIOS()
    {
        PlayerSettings.iOS.sdkVersion = iOSSdkVersion.DeviceSDK;
        BuildIOS(iosExportPath);
    }
    public static void DoBuildIOSSimulator()
    {
        PlayerSettings.iOS.sdkVersion = iOSSdkVersion.SimulatorSDK;
        BuildIOS(iosExportPath);
    }


    private static void BuildIOS(String path)
    {
        if (Directory.Exists(path))
            Directory.Delete(path, true);

        EditorUserBuildSettings.iOSBuildConfigType = iOSBuildType.Release;

        var options = BuildOptions.AllowDebugging;
        var report = BuildPipeline.BuildPlayer(
            GetEnabledScenes(),
            path,
            BuildTarget.iOS,
            options
        );

        if (report.summary.result != BuildResult.Succeeded)
            throw new Exception("Build failed");
    }

    static void Copy(string source, string destinationPath)
    {
        if (Directory.Exists(destinationPath))
            Directory.Delete(destinationPath, true);

        Directory.CreateDirectory(destinationPath);

        foreach (string dirPath in Directory.GetDirectories(source, "*",
            SearchOption.AllDirectories))
            Directory.CreateDirectory(dirPath.Replace(source, destinationPath));

        foreach (string newPath in Directory.GetFiles(source, "*.*",
            SearchOption.AllDirectories))
            File.Copy(newPath, newPath.Replace(source, destinationPath), true);
    }

    static string[] GetEnabledScenes()
    {
        var scenes = EditorBuildSettings.scenes
            .Where(s => s.enabled)
            .Select(s => s.path)
            .ToArray();

        return scenes;
    }

    /// <summary>
    /// This method tries to autome the build setup required for Android
    /// </summary>
    static void SetupAndroidProject()
    {
        string androidPath = Path.GetFullPath(Path.Combine(ProjectPath, "../../android"));
        string androidAppPath = Path.GetFullPath(Path.Combine(ProjectPath, "../../android/app"));
        var proj_build_path = Path.Combine(androidPath, "build.gradle");
        var app_build_path = Path.Combine(androidAppPath, "build.gradle");
        var settings_path = Path.Combine(androidPath, "settings.gradle");

        var proj_build_script = File.ReadAllText(proj_build_path);
        var settings_script = File.ReadAllText(settings_path);
        var app_build_script = File.ReadAllText(app_build_path);

        // Sets up the project build.gradle files correctly
        if (!Regex.IsMatch(proj_build_script, @"flatDir[^/]*[^}]*}"))
        {
            Regex regex = new Regex(@"allprojects \{[^\{]*\{", RegexOptions.Multiline);
            proj_build_script = regex.Replace(proj_build_script, @"
allprojects {
    repositories {
        flatDir {
            dirs ""${project(':unityLibrary').projectDir}/libs""
        }
");
            File.WriteAllText(proj_build_path, proj_build_script);
        }

        // Sets up the project settings.gradle files correctly
        if (!Regex.IsMatch(settings_script, @"include "":unityLibrary"""))
        {
            settings_script += @"

include "":unityLibrary""
project("":unityLibrary"").projectDir = file(""./unityLibrary"")
";
            File.WriteAllText(settings_path, settings_script);
        }


        // Sets up the project app build.gradle files correctly
        if (!Regex.IsMatch(app_build_script, @"dependencies \{"))
        {
            app_build_script += @"
dependencies {
    implementation project(':unityLibrary')
}
";
            File.WriteAllText(app_build_path, app_build_script);
        } else
        {
            if (!app_build_script.Contains(@"implementation project(':unityLibrary')"))
            {
                Regex regex = new Regex(@"dependencies \{", RegexOptions.Multiline);
                app_build_script = regex.Replace(app_build_script, @"
dependencies {
    implementation project(':unityLibrary')
");
                File.WriteAllText(app_build_path, app_build_script);
            }
        }
    }

}
