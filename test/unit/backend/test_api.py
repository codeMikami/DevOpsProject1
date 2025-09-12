
import requests

def test_profile_endpoint():
    response = requests.get("http://localhost:5000/profile")
    assert response.status_code == 200
    assert response.json().get("name") == "Nagato"  # Замени на ожидаемый ответ