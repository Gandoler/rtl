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
