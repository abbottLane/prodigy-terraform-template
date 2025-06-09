import prodigy
from prodigy.components.loaders import JSONL
from prodigy.util import set_hashes

@prodigy.recipe("textcat.custom")
def textcat_custom(dataset, source, label):
    """
    Custom text classification recipe for movie review sentiment analysis.
    
    dataset (str): Name of dataset to save annotations to
    source (str): Path to JSONL file with texts to annotate  
    label (str): Comma-separated list of labels
    """
    
    # Parse labels
    labels = [label.strip() for label in label.split(",")]
    
    # Load the data
    stream = JSONL(source)
    
    # Add task hashes
    stream = set_hashes(stream)
    
    return {
        "dataset": dataset,
        "stream": stream,
        "view_id": "classification",
        "config": {
            "labels": labels,
            "choice_style": "single",  # Allow only one label per example
            "choice_auto_accept": False,  # Require explicit accept/reject
            "batch_size": 1,  # Show one example at a time
            "show_stats": True,  # Show annotation statistics
        }
    }