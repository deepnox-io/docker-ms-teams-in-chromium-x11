FROM deepnox/chromium-x11:dt-20230312T1515

ARG TEAMS_URL="https://teams.microsoft.com"


CMD ["chromium-browser", \ 
     "--allow-silent-push", \
     "--homepage=https://teams.microsoft.com", \
     "--app=https://teams.microsoft.com" \
     ]
