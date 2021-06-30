using UnityEditor;

public class BuildWindow : EditorWindow
{

    [MenuItem("Flutter/Export Android %&n", false, 1)]
    public static void DoBuildAndroid()
    {
        Build.DoBuildAndroid();
    }


    [MenuItem("Flutter/Export IOS %&i", false, 2)]
    public static void DoBuildIOS()
    {
        Build.DoBuildIOS();
    }

    [MenuItem("Flutter/Export IOS Simulator %&s", false, 3)]
    public static void DoBuildIOSSimulator()
    {
        Build.DoBuildIOSSimulator();
    }

}
