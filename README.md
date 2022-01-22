This template repo is intended to set up a cicd workflow that
runs test builds on branches and deploys to itchio from main

Initial Template Setup
======================
Setting Up License
------------------
Before you can run the unity-builder action, you'll need to create a unity license:

- Move activation.yml to `.github/workflows`
- Push code to trigger action
- Upload it at license.unity3d.com to receive your `.ulf` file
- Add the contents to a secret named UNITY_LICENSE in Settings > Secrets
- Remove the action from workflows

Set up Builds and Deploys
-------------------------
Move the contents of the `workflows/` directory to `.github/workflows/` in
the root of this repo
In the release.yml file:
- replace `PROJECT_NAME` with the name for your game (must be valid file path)
- replace `USER_NAME` with your itchio username

Set up an Itch.io Project
-------------------------
Navigate to https://itch.io/game/new and make sure you use the PROJECT_NAME from above

Select HTML as the "Kind of Project"

Probably set Release status to Prototype and leave as Draft

Set up a Unity Project
----------------------
I haven't found a clean way to set this up in repo root path. My workaround is to

1) From Unity Hub on your machine and start a new project in the repo root
2) mv the contents of that project into to root itself and rmdir the empty dir
3) In Unity Hub remove the project from the list
4) Add the project back to Unity Hub from it's new location at the root of the repo


Local Testing
=============
From the Build directory, start a server: `python -m http.server --cgi 8360`
Then access the server via: `http://localhost:8360/index.html`
