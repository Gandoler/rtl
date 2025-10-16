# то что никак не получаеться запомнить:

## переключение на другую удаленную ветку

```bash
git fetch -a
git branch -r
git checkout -b feature-branch origin/feature-branch
```


## удаление из трека при добавление .gitignore

```bash
git rm -r --cached .
git add .
git commit -m "Обновлён .gitignore, удалены лишние файлы из индекса"
```


## вытягивание обновлений основной ветки в свою
* Убедись, что у тебя свежий main
```bash
git fetch origin
git checkout main
git pull origin main
```

* Переключись обратно на свою ветку
```bash
git checkout feature/some-task
```

* Применяем коммиты поверх обновлённого main
```bash
git rebase main
```
