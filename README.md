# Курсовая работа с курса «Хранение данных»

## Учебный проект [профессии «iOS-разработчик с нуля»](https://netology.ru/programs/ios-developer) от онлайн-университета Нетология.

**Язык**: Swift.

**Блок**: Хранение данных. CoreData.

**Архитектура**: MVVM.

**Основные возможности**:

1. Авторизация текущего пользователя с помощью логина и пароля, либо с помощью полученного от сервера токена.
2. Отображение ленты публикаций пользователей, на которых подписан текущий пользователь.
3. Просмотр профилей пользователей.
4. Добавление новых публикаций с возможностью применения фильтров к публикуемым изображениям.
5. Добавление/снятие лайка к публикации.
6. Просмотр списка лайкнувших публикацию пользователей.
7. Подписка/отписка от пользователей.
8. Просмотр подписчиков и тех, на кого подписан пользователь.

**Особенности реализации**:

1. В случае успешной авторизации по логину и паролю, полученный от сервера токен сохраняется в **Keychain**.
2. При повторном запуске приложения происходит проверка наличия сохранённого токена, после чего выполняется запрос к серверу на его валидность. Если токен оказываетя валидным, происходит автоматическая авторизация пользователя, в противном случае токен удаляется.
3. Если при запуске приложения обнаруживается сохранённый токен, но сервер оказывается недоступен, приложение переходит в оффлайн режим работы, при котором возможен просмотр полученных ранее в онлайн режиме данных.
4. В онлайн режиме получаемые от сервера данные сохраняются в локальное хранилище. Хранение данных реализовано с использованием **CoreData**.
5. Работа с сетью реализована нативными средствами.
6. Загрузка изображений осуществляется с помощью фреймворка **Kingfisher**.
7. Выбор новых изображений для публикации в данной реализации приложения доступен только из ограниченного числа имеющихся в коллекции изображений.

Вёрстка интерфейса преимущественно выполнялась с использованием XIB-файлов. Несколько экранов реализованы в коде.