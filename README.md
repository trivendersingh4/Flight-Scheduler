# Flight-Scheduler
1. To run the webapp, we need Node.js and npm package manager. Download and install them and add them to PATH.
2. Open MySQL workbench and create a connection with username `root` and password `password`.
3. Open DBS_PR_11_Code_2017B4PS1227P and execute the script.
4. Open the terminal and navigate to the folder DBS_PR_11_Code_2017B4PS1227P.
5. Type `cd client`, then `npm install` to install node modules for the frontend.
6. Type `cd ../server` then `npm install` to install node moules for the backend.
7. Now, in the server folder itself, type `npm run dev` to concurrently run the client and server.
8. Click on the Schedule tab to see the flights and their arrival.
9. Click on Login tab to enter details and then submit the form. After being redirected, refresh the page to see changes.
10. If flight is within 5 minutes of another, an error message will be displayed on the terminal.