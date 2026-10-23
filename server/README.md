
## Android
```
gomobile bind -ldflags="-w -s -X github.com/david88558855/arctic-fox-disk/server/internal/app.VERSION=1.2.0" -o ../app/android/app/libs/libserver.aar -target=android -androidapi 21 -javapkg="com.arcticfox.disk" github.com/david88558855/arctic-fox-disk/server/cmd/mobile
```

## IOS
```
gomobile bind -ldflags="-w -s -X github.com/david88558855/arctic-fox-disk/server/internal/app.VERSION=1.2.0" -o ../app/ios/Frameworks/libserver.xcframework -target=ios github.com/david88558855/arctic-fox-disk/server/cmd/mobile
```

## MacOS
```
go build -ldflags="-w -s -X github.com/david88558855/arctic-fox-disk/server/internal/app.VERSION=1.2.0" -buildmode=c-shared -o ../app/macos/Frameworks/libserver.dylib github.com/david88558855/arctic-fox-disk/server/cmd/desktop
```

## Windows
```
set CGO_ENABLED=1
go build -ldflags="-w -s -X github.com/david88558855/arctic-fox-disk/server/internal/app.VERSION=1.2.0" -buildmode=c-shared -o ../app/windows/libserver.dll github.com/david88558855/arctic-fox-disk/server/cmd/desktop
```

## Linux
```
go build -ldflags="-w -s -X github.com/david88558855/arctic-fox-disk/server/internal/app.VERSION=1.2.0" -buildmode=c-shared -o ../app/linux/libserver.so github.com/david88558855/arctic-fox-disk/server/cmd/desktop
```
