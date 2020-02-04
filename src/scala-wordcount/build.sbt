name := "wordcount"

version := "1.0"

organization := "jbcodeforce"

scalaVersion := "2.12.3"
libraryDependencies ++= Seq(
"org.apache.spark" %% "spark-core" % "3.0.0-preview" % "provided"
)
