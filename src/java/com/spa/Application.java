package com.spa;

import org.apache.catalina.Context;
import org.apache.catalina.LifecycleException;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

import java.io.File;

public class Application {

  private static final int DEFAULT_PORT = 8080;
  private static final String WEBAPP_DIR = "web/";
  private static final String CONTEXT_PATH = "";

  public static void main(String[] args) throws LifecycleException {

    // Get port from environment variable (Railway sets this)
    String portStr = System.getenv("PORT");
    int port = portStr != null ? Integer.parseInt(portStr) : DEFAULT_PORT;

    System.out.println("Starting Spa Management System on port: " + port);

    // Create Tomcat instance
    Tomcat tomcat = new Tomcat();
    tomcat.setPort(port);
    tomcat.getConnector(); // Trigger the creation of the default connector

    // Set up the web application
    File webappDir = new File(WEBAPP_DIR);
    if (!webappDir.exists()) {
      webappDir = new File("src/main/webapp");
    }
    if (!webappDir.exists()) {
      // Try to find webapp directory in classpath
      webappDir = new File(".");
    }

    String webappDirLocation = webappDir.getAbsolutePath();
    System.out.println("Webapp directory: " + webappDirLocation);

    // Create context
    Context context = tomcat.addWebapp(CONTEXT_PATH, webappDirLocation);

    // Add resources for development (if classes directory exists)
    File classesDir = new File("build/classes");
    if (classesDir.exists()) {
      StandardRoot resources = new StandardRoot(context);
      resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
          classesDir.getAbsolutePath(), "/"));
      context.setResources(resources);
    }

    // Configure session timeout (30 minutes)
    context.setSessionTimeout(30);

    // Add shutdown hook
    Runtime.getRuntime().addShutdownHook(new Thread(() -> {
      try {
        System.out.println("Shutting down Tomcat...");
        tomcat.stop();
        tomcat.destroy();
      } catch (LifecycleException e) {
        System.err.println("Error during shutdown: " + e.getMessage());
      }
    }));

    try {
      // Start the server
      tomcat.start();
      System.out.println("Spa Management System started successfully!");
      System.out.println("Access the application at: http://localhost:" + port);

      // Keep the server running
      tomcat.getServer().await();

    } catch (LifecycleException e) {
      System.err.println("Failed to start Tomcat: " + e.getMessage());
      e.printStackTrace();
      System.exit(1);
    }
  }
}