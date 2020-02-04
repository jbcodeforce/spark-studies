name := "wordcount"

version := "1.0"

organization := "com.sundogsoftware"

scalaVersion := "2.12.3"
//scalaVersion := "2.11.8"

libraryDependencies ++= Seq(
"org.apache.spark" %% "spark-core" % "3.0.0-preview" % "provided"
//"org.apache.spark" %% "spark-core" % "2.4.4" % "provided"
)
