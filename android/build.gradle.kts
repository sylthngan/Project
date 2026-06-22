allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

/**
 * 1. Sửa lỗi Circular evaluation
 */
val rootBuildDir = layout.projectDirectory.dir("../build")
rootProject.layout.buildDirectory.set(rootBuildDir)

subprojects {

    project.layout.buildDirectory.set(
        rootBuildDir.dir(project.name)
    )
}

/**
 * 2. Fix geolocator / flutter property
 */
subprojects {

    val injectFlutterConfig = {

        val android = project.extensions.findByName("android")

        if (android != null &&
            android is org.gradle.api.plugins.ExtensionAware
        ) {

            val extraProperties =
                android.extensions.extraProperties

            if (!extraProperties.has("flutter")) {

                extraProperties.set(
                    "flutter",
                    mapOf(
                        "compileSdkVersion" to 35,
                        "targetSdkVersion" to 35,
                        "minSdkVersion" to 23
                    )
                )
            }
        }
    }

    if (project.state.executed) {
        injectFlutterConfig()
    } else {
        project.afterEvaluate {
            injectFlutterConfig()
        }
    }

    if (project.name != "app") {
        try {
            project.evaluationDependsOn(":app")
        } catch (_: Exception) {
        }
    }
}

/**
 * 3. Clean task
 */
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}