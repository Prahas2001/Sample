from pydantic import BaseModel, Field
from typing import List, Optional

class RiskItem(BaseModel):
    clause: str = Field(description="The specific text from the document that poses a risk")
    severity: str = Field(description="High, Medium, or Low")
    reason: str = Field(description="Explanation of why this is a risk")

class DocumentExtraction(BaseModel):
    document_type: str = Field(description="e.g., Employment Agreement, ID Card, Invoice")
    entity_name: str = Field(description="The primary person or organization the document belongs to")
    id_number: Optional[str] = Field(description="Any identification number found (SSN, Student ID, etc.)")
    issue_date: Optional[str] = Field(description="The date the document was issued or signed")
    summary: str = Field(description="A 2-sentence overview of the document")
    risks: List[RiskItem] = Field(description="A list of specific legal or data risks found")
    action_items: List[str] = Field(description="Recommended next steps for the user")

    


# -- D Ram Prahasith Sharma.