
import axios from 'axios';

const baseUrl = 'http://localhost:9000';

export async function getGraphMe(token) {
    const url = `${baseUrl}/graph/me`;

    const options = {
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
        },
    };

    const response = await axios.get(url, options);
    return response.data;
}

export async function getLicenseDetails(mails, token) {
    const url = `${baseUrl}/graph/users/licenseDetails`;

    const options = {
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
        },
    };

    const response = await axios.post(url, { mails: mails }, options);
    return response.data;
}

export async function revokeSignInSession(mails, token) {
    const url = `${baseUrl}/graph/users/revokeSignInSession`;

    const options = {
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
        },
    };

    const response = await axios.post(url, { mails: mails }, options);
    return response.data;
}


