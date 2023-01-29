# DevOps
Gitlab was used during developemnt. Together with Avit Group (IT partner of TeamNL) a devops pipeline has been set up on Azure to automatically create a server and build/start the web application whenever a commit is pushed to the `main` branch.<br>

Because Azure DevOps can't reach the private repository on the HvA GitLab. A mirror is setup to mirror the GitLab repository to a public GitHub repository <a target="_blank" href="https://github.com/serg-and/team-nl-iot-2022">github.com/serg-and/team-nl-iot-2022</a>. This this repository is then mirrored to the Azure DevOps repository.<br>

There is also a pipeline on GitLab to automatically rebuild the documentation site whenever a commit is pushed to the `main` branch.