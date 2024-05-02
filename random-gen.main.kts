#!/usr/bin/env kotlin

@file:Repository("https://repo.maven.apache.org/maven2/")
@file:DependsOn("com.google.code.gson:gson:2.10.1")

import com.google.gson.GsonBuilder
import java.io.File
import kotlin.random.Random

if (!File("data").exists()) {
    File("data").mkdir()
} else {
    File("data").listFiles().forEach { it.delete() }
}

data class Pos(val x: Int, val y: Int)
data class Instance(val width: Int, val height: Int, val agents: Int, val start: List<Pos>, val goal: List<Pos>, val time:Int)

val instances = mutableListOf<Instance>()
(10..50 step 10).forEach { gridSize ->
    (5..20 step 5).forEach { agentCount ->
        val startPos = mutableSetOf<Pos>()
        val endPos = mutableSetOf<Pos>()
        while (startPos.count() < agentCount) startPos.add(Pos(Random.nextInt(0, gridSize), Random.nextInt(0, gridSize)))
        while (endPos.count() < agentCount) endPos.add(Pos(Random.nextInt(0, gridSize), Random.nextInt(0, gridSize)))
        instances.add(
            Instance(gridSize, gridSize, agentCount, startPos.toList(), endPos.toList(), gridSize*2)
        )
    }
}

val gson = GsonBuilder().setPrettyPrinting().create()
instances.forEach { instance ->
    val content = gson.toJson(instance)
    val file = File("data/${instance.width}x${instance.height}_${instance.agents}.json")
    file.writeText(content)
}
