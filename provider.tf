provider "google" {
  project = "quick-assesment" 
  region  = "us-central1"
  credentials =  file("./json.json")       
}

