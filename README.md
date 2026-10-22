Скачиваем там где есть интернет, и переносим на рабочий сервер

```
./download.sh
```


Устанавливаем 
```bash
ansible-playbook -i inventory.ini playbook.yml -e api_key=SECRET
```

дефолтная модель unsloth/gemma-3-4b-it, ее можно поменять через -e model=


проверка
```bash
curl http://SERVER:8000/v1/chat/completions \
  -H "Authorization: Bearer SECRET" \
  -H "Content-Type: application/json" \
  -d '{"model": "unsloth/gemma-3-4b-it", "messages": [{"role": "user", "content": "Привет!"}]}'
```
