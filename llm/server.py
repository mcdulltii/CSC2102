from starlette.applications import Starlette
from starlette.responses import JSONResponse
from starlette.routing import Route
import asyncio
import torch
import tensorflow as tf
from transformers import AutoModelForCausalLM, AutoTokenizer, GenerationConfig
from typing import Dict, List

tokenizer = None
model = None


def drsamantha_init() -> None:
    global tokenizer, model
    tokenizer = AutoTokenizer.from_pretrained("sethuiyer/Dr_Samantha-7b")
    model = AutoModelForCausalLM.from_pretrained("sethuiyer/Dr_Samantha-7b").to("cuda")


def drsamantha_infer(
        prompt: str,
        temperature: float = 0.1,
        top_p: float = 0.75,
        top_k: int = 40,
        num_beams: int = 2,
        **kwargs,
) -> str:
    global tokenizer, model
    inputs = tokenizer(prompt, return_tensors="pt")
    input_ids = inputs["input_ids"].to("cuda")
    attention_mask = inputs["attention_mask"].to("cuda")
    generation_config = GenerationConfig(
        temperature=temperature,
        top_p=top_p,
        top_k=top_k,
        num_beams=num_beams,
        **kwargs,
    )
    with torch.no_grad():
        generation_output = model.generate(
            input_ids=input_ids,
            attention_mask=attention_mask,
            generation_config=generation_config,
            return_dict_in_generate=True,
            output_scores=True,
            max_new_tokens=512,
            eos_token_id=tokenizer.eos_token_id

        )
    s = generation_output.sequences[0]
    output = tokenizer.decode(s, skip_special_tokens=True)
    return output


async def get_model_inference(request) -> JSONResponse:
    payload = await request.body()
    string = payload.decode("utf-8")
    response_q = asyncio.Queue()
    await request.app.model_queue.put((string, response_q))
    output = await response_q.get()
    return JSONResponse(output)


async def server_loop(q) -> None:
    while True:
        (string, response_q) = await q.get()
        out = drsamantha_infer(string)
        await response_q.put(out)


app = Starlette(
    routes=[
        Route("/api/getModelInf", get_model_inference, methods=["POST"]),
    ],
)


@app.on_event("startup")
async def startup_event() -> None:
    # Assert GPU detected
    assert len(tf.config.list_physical_devices('GPU')) > 0

    # Initialize LLM
    drsamantha_init()

    # Initialize server model queue
    q = asyncio.Queue()
    app.model_queue = q
    asyncio.create_task(server_loop(q))
