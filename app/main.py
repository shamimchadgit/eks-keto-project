from fastapi import FastAPI, Request, Form
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles

app = FastAPI()
templates = Jinja2Templates(directory="templates")
app.mount("/static", StaticFiles(directory="static"), name="static")

@app.get("/", response_class=HTMLResponse)
async def read_item(request: Request):
    return templates.TemplateResponse("index.html", {"request": request, "results": None})

@app.post("/", response_class=HTMLResponse)
async def calculate_keto(
    request: Request,
    weight: float = Form(...),
    height: float = Form(...),
    age: int = Form(...),
    gender: str = Form(...),
    activity: float = Form(...),
    net_carbs: int = Form(...)
):
    
    if gender == "male":
        bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5
    else:
        bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161
        
    tdee = bmr * activity
    
    carb_cals = net_carbs * 4
    
    protein_g = weight * 1.0
    protein_cals = protein_g * 4
    
    remaining_cals = tdee - (carb_cals + protein_cals)
    fat_g = max(0, remaining_cals / 9)
    
    results = {
        "tdee": round(tdee),
        "fat_g": round(fat_g),
        "protein_g": round(protein_g),
        "carb_g": net_carbs
    }
    
    return templates.TemplateResponse("index.html", {"request": request, "results": results})
