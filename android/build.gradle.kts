allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    val configureBetterPlayer = {
        if (project.name == "better_player") {
            val android = project.extensions.findByName("android")
            if (android != null) {
                try {
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    setNamespace.invoke(android, "com.jhomlala.better_player")
                } catch (e: Exception) {
                    println("Failed to set namespace for better_player: ${e.message}")
                }
            }
        }
    }
    if (project.state.executed) {
        configureBetterPlayer()
    } else {
        project.afterEvaluate {
            configureBetterPlayer()
        }
    }
}
