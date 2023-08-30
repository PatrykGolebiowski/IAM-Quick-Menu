import requests
from fastapi import APIRouter, Header, HTTPException

from helpers.helper import load_licensing_data
from models.graph_models import GraphMeResponse, LicenseDetail, Mails


router = APIRouter()


@router.get('/graph/me', response_model=GraphMeResponse)
def graph_me(authorization: str = Header(...)):
    access_token = authorization.split(' ')[1]
    
    headers = {
        'Authorization': f"Bearer {access_token}"
    }
    
    url = 'https://graph.microsoft.com/v1.0/me'

    response = requests.get(url, headers=headers)
    data = response.json()

    return data


@router.post('/graph/users/licenseDetails', response_model=list[LicenseDetail])
def graph_users_license_details(mails: Mails, authorization: str = Header(...)):
    access_token = authorization.split(' ')[1]
    headers = {
        'Authorization': f"Bearer {access_token}"
    }

    licensing_data = load_licensing_data()

    result = []
    for mail in mails.mails:
        url = f"https://graph.microsoft.com/v1.0/users/{mail}/licenseDetails"
        response = requests.get(url, headers=headers)

        if response.status_code == 404:
            raise HTTPException(status_code=404, detail=f"The requested resource {mail} was not found.")

        data = response.json()
        licenses = data['value']

        temp_result = {
                'mail': mail,
                'assignedLicenses': [],
                'enabledServicePlans': []
        }

        for license in licenses:
            sku_id = license['skuId']
            service_plans = license['servicePlans']

            product_display_name = licensing_data.get(sku_id, 'Unknown')
            temp_result['assignedLicenses'].append(product_display_name)

            for service_plan in service_plans:

                service_plan_id = service_plan['servicePlanId']
                service_plan_name = licensing_data.get(service_plan_id, 'Unknown')

                temp_result['enabledServicePlans'].append(service_plan_name)
                temp_result['enabledServicePlans'].sort()

        result.append(temp_result)

    print(result)

    return result


@router.post('/graph/users/revokeSignInSession')
def graph_revoke_sign_in_session(mails: Mails, authorization: str = Header(...)):
    access_token = authorization.split(' ')[1]
    headers = {
        'Authorization': f"Bearer {access_token}"
    }

    result = []
    for mail in mails.mails:
        url_revoke_session = f"https://graph.microsoft.com/v1.0/users/{mail}/revokeSignInSessions"
        response = requests.post(url_revoke_session, headers=headers)

        if response.status_code == 404:
                    raise HTTPException(status_code=404, detail=f"The requested resource {mail} was not found.")
        
        data_session = response.json()
        revoke_session_status = data_session['value']

        temp_result = {
            'mail': mail,
            'signInSessionRevoked': revoke_session_status,
        }

        result.append(temp_result)

    return result