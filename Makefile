push:
	git add -A
	git commit -m "up"
	git push


unity_app = /Applications/Unity/Hub/Editor/2019.4.27f1/Unity.app/Contents/MacOS/Unity
project_path = unity/unity_project/
codePostBuild = ${project_path}/Assets/FlutterUnityIntegration/Editor/XCodePostBuild.cs
grpcPostBuild = ${project_path}/Assets/FlutterUnityIntegration/Editor/GrpcPostBuild.cs
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
	sed 's+#if UNITY_IOS+// #if UNITY_IOS+g' ${codePostBuild} > .temp.cs && mv .temp.cs ${codePostBuild}
	sed 's+#if UNITY_IOS+// #if UNITY_IOS+g' ${grpcPostBuild} > .temp.cs && mv .temp.cs ${grpcPostBuild}
	sed 's+#endif+// #endif+g' ${codePostBuild} > .temp.cs && mv .temp.cs ${codePostBuild}
	sed 's+#endif+// #endif+g' ${grpcPostBuild} > .temp.cs && mv .temp.cs ${grpcPostBuild}


disable_config_ios:
	sed 's+// #if UNITY_IOS+#if UNITY_IOS+g' ${codePostBuild} > .temp.cs && mv .temp.cs ${codePostBuild}
	sed 's+// #if UNITY_IOS+#if UNITY_IOS+g' ${grpcPostBuild} > .temp.cs && mv .temp.cs ${grpcPostBuild}
	sed 's+// #endif+#endif+g' ${codePostBuild} > .temp.cs && mv .temp.cs ${codePostBuild}
	sed 's+// #endif+#endif+g' ${grpcPostBuild} > .temp.cs && mv .temp.cs ${grpcPostBuild}
