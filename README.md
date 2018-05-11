# JNTSeniorProjectGit
Jack Demm, Natalie Sequeira, Thomas Zorn
Due-It!

# GETTING STARTED

Open Xcode, and start a new project. Choose “Page-Based App” and make sure the language is set to Swift (it should be). After you have created the project, close Xcode, because we need to install one more piece of software.The other piece of software that needs to be installed is Cocoapods, which is a package manager for installing add-on packages to use in your app. To install Cocoapods: 

Go into your terminal, and type: sudo gem install cocoapods
After that finishes, type: pod setup
In the terminal, go to the directory where your project files are stored, and type: pod init
There should now be a Podfile in that directory. Open that in a text editor, and append it to be the following:

target ‘yourProjectName’ do
use frameworks!
pod ‘JTAppleCalendar’, ‘~> 7.0’
end

In our case, we are using a pod called JTAppleCalendar, which allows us to more easily create a visual calendar for our app. Apple itself does not provide a default method for implementing a graphical calendar.
Save this file, and in the same terminal (and in the same directory) type: pod install
That should be it for installing Cocoapods, you can open Xcode again, where you will now open the project from the ‘.workspace’ file from now on.

# HOW TO RUN

# Running Due-It!

1. Install cocoapods and JT Apple Calendar using the directions in the “Getting Started” section of this document. 
2. Download the source code provided in moodle (or clone it from GitHub)
3. Open the .xcworkspace file in the project folder. Run the pod install command in the terminal in the directory on the project.
4. Build the project by doing the shortcut ‘Command + b.’ After the build succeeds you can hit either the play button at the top left of the screen in XCode, or you can do the command ‘Command + r’ to run the app.
5.A simulator will open with the app running and you’re good to go!

