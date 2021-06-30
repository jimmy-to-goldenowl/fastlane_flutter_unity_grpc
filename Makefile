push:
	git add -A
	git commit -m "up"
	git push


unity_app = /Applications/Unity/Hub/Editor/2019.4.27f1/Unity.app/Contents/MacOS/Unity
project_path = unity/unity_project/
codePostBuild = ${project_path}/Assets/FlutterUnityIntegration/Editor/XCodePostBuild.cs
# all: unity_ios unity_android
unity_ios:
	make enable_config_ios
	${unity_app} -quit -bachmode -projectPath ${project_path} -executeMethod Build.DoBuildIOS
	make disable_config_ios
	echo "Export Unity iOS Complete"

unity_ios_simulator:
	make enable_config_ios
	${unity_app} -quit -bachmode -projectPath ${project_path} -executeMethod Build.DoBuildIOSSimulator
	make disable_config_ios
	echo "Export Unity iOS Complete"

unity_android:
	${unity_app} -quit -bachmode -projectPath ${project_path} -executeMethod Build.DoBuildAndroid
	echo "Export Unity Android Complete"

enable_config_ios:
	sed 's+#if UNITY_IOS+// #if UNITY_IOS+g' ${codePostBuild} > codePostBuild_temp.cs
	mv codePostBuild_temp.cs ${codePostBuild}
	sed 's+#endif+// #endif+g' ${codePostBuild} > codePostBuild_temp.cs
	mv codePostBuild_temp.cs ${codePostBuild}


disable_config_ios:
	sed 's+// #if UNITY_IOS+#if UNITY_IOS+g' ${codePostBuild} > codePostBuild_temp.cs
	mv codePostBuild_temp.cs ${codePostBuild}
	sed 's+// #endif+#endif+g' ${codePostBuild} > codePostBuild_temp.cs
	mv codePostBuild_temp.cs ${codePostBuild}
