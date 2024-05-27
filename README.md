# flutter_mapbox_app

A new Flutter project.

# How to run the Application
clone the application, and open it in android studio. Choose android emulator for running it in android device and, choose ios simulator for running in iOS device.
flutter run command can use for runningthe application.

# Step-by-Step Guide

1.  Create a Flutter Project
2. Add Mapbox Dependency
3. Configure iOS and Android :  To use Mapbox on iOS, updated Info.plist, and in android AndroidManifest.xml
4. Mapbox account and mapbox configuration: Created personal mapbox account and used own secret key and public key.
5. Polygon is created using polygonannotation manager. Each polygon vertex is created uisnig Point Annotation Manager.
6. In each point dragging, calculationing the coordinate difference and from old vertx to new point and based on that polygon vertex list is updated.

 # Challenges Faced
 
 1. Point annptation manager listener only deleting on click action(single tap action). So there was no way to listen the dragging of polygon vertex dragging. I spent more time for this, finally i added longpress gesture to the map, and on log press calculating which vertex is nearer and caluculting movment distance and then updates the polygon vertex list.
