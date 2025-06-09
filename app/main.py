import os
import subprocess
import sys
from dotenv import load_dotenv

load_dotenv()

def main():
    """Start Prodigy server"""
    # Set Prodigy environment variables
    os.environ["PRODIGY_HOST"] = "0.0.0.0"
    os.environ["PRODIGY_PORT"] = str(os.environ.get("PORT", 8080))
    
    # Run prodigy with basic configuration
    cmd = [
        "python", "-m", "prodigy", 
        "textcat.manual", "dataset",
        "/app/config/instructions.html",
        "--label", "POSITIVE,NEGATIVE"
    ]
    
    subprocess.run(cmd)

if __name__ == "__main__":
    main()