import com.typesafe.sbt.SbtNativePackager._
import com.typesafe.sbt.packager.Keys._

packageArchetype.java_application

name := "PTS_TRADER"

packageDescription := "PTS"

maintainer := "tamutamu"

version := "0.1.0"

scalaVersion := "2.10.0"

libraryDependencies += "org.scalatest" %% "scalatest" % "1.9.1" % "test"

libraryDependencies += "org.seleniumhq.webdriver" % "webdriver-htmlunit" % "0.9.7376"

libraryDependencies += "com.twitter" % "util-eval" % "1.12.13" withSources()

resolvers += "T repo" at "http://maven.twttr.com/"