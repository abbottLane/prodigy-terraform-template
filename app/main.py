import os
import prodigy
from prodigy import set_hashes
from dotenv import load_dotenv

load_dotenv()

def create_prodigy_app():
    """Create and configure Prodigy app"""
    app = prodigy.create_app()
    return app

if __name__ == "__main__":
    app = create_prodigy_app()
    port = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=port)