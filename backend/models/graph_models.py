from pydantic import BaseModel, Field
from typing import List, Optional

class LicenseDetail(BaseModel):
    mail: str
    assignedLicenses: List[str]
    enabledServicePlans: List[str]

class UserLicenseDetail(BaseModel):
    mail: str
    licenses: List[LicenseDetail]

class GraphMeResponse(BaseModel):
    businessPhones: List[str]
    displayName: str
    givenName: str
    jobTitle: Optional[str] = None
    mail: Optional[str] = None
    mobilePhone: Optional[str] = None
    officeLocation: Optional[str] = None
    preferredLanguage: Optional[str] = None
    surname: str
    userPrincipalName: str
    id: str

class GraphUsersLicenseDetailsResponse(BaseModel):
    details: List[UserLicenseDetail]

class Mails(BaseModel):
    mails: List[str] = Field(...)