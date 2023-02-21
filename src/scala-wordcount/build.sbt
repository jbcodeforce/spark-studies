name := "wordcount"
pwd
version := "1.0"

organization := "jbcodeforce"

scalaVersion := "2.13"
libraryDependencies ++= Seq(
"org.apache.spark" %% "spark-core" % "3.3.2" % "provided"
)
