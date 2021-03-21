*** Variables ***
#${DOMAIN_URL}    %{DOMAIN_URL}
${DOMAIN_URL}    http://127.0.0.1:8000
${CELERY_BACKEND}    db+postgresql://spoonbilluser:spoonbillpwd@127.0.0.1/spoonbill
${POSTGRES_DB}    spoonbill
${POSTGRES_USER}    spoonbilluser
${POSTGRES_PASSWORD}    spoonbillpwd

