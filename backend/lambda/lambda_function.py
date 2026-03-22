import json
import boto3
import os
import models 
import prompt 
from google import genai
from google.genai import types

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    bucket_name = os.environ.get('S3_BUCKET_NAME', 'risk-analysing-app-data')
    
    cors_headers = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, X-Amz-Date, Authorization, X-Api-Key, X-Amz-Security-Token'
    }
    
    try:
        # 1. Setup Client
        api_key = os.environ.get('GEMINI_API_KEY')
        client = genai.Client(api_key=api_key)
        
        # 2. Get body from request
        body = json.loads(event.get('body', '{}')) if isinstance(event.get('body'), str) else event.get('body', {})
        file_key = body.get('fileName')
        user_custom_input = body.get('userPrompt', "")
        
        if not file_key:
            return {'statusCode': 400, 'headers': cors_headers, 'body': json.dumps({"error": "No file"})}
        
        # 3. Download from S3
        local_path = f"/tmp/{os.path.basename(file_key)}"
        s3.download_file(bucket_name, file_key, local_path)
        
        # 4. Determine MIME Type
        mime_type = 'application/pdf' if file_key.lower().endswith('.pdf') else 'image/jpeg'
        
        with open(local_path, "rb") as f:
            file_data = f.read()
            
        # 5. Call Gemini
        response = client.models.generate_content(
            model='gemini-2.5-flash-lite',
            contents=[
                prompt.get_analysis_prompt(user_custom_input),
                types.Part.from_bytes(data=file_data, mime_type=mime_type)
            ],
            config=types.GenerateContentConfig(
                system_instruction=prompt.SYSTEM_PROMPT,
                response_mime_type='application/json',
                response_schema=models.DocumentExtraction,
            )
        )
        
        # FIX: Ensure this line has exactly the same indentation as 'response ='
        analysis_results = response.parsed.model_dump() if hasattr(response.parsed, 'model_dump') else response.parsed

        return {
            'statusCode': 200,
            'headers': cors_headers,
            'body': json.dumps({
                "message": "Success",
                "data": analysis_results
            })
        }
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': cors_headers,
            'body': json.dumps({"error": str(e)})
        }
    


# -- D Ram Prahasith Sharma.