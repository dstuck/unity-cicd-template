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

Set up a Unity Project
----------------------
Open unity on your machine and start a new project in the root of this directory


Local Testing
=============
From the Build directory, start a server: `python -m http.server --cgi 8360`
Then access the server via: `http://localhost:8360/index.html`
