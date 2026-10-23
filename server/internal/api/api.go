package api

import (
	"github.com/david88558855/arctic-fox-disk/server/internal/api/base"
	"github.com/david88558855/arctic-fox-disk/server/internal/api/file"
	"github.com/david88558855/arctic-fox-disk/server/internal/api/shared"
	"github.com/samber/do/v2"
)

type Service = shared.Service
type Services = shared.Services

func Provide(i do.Injector) {
	base.Provide(i)
	file.Provide(i)

	do.Provide(i, func(i do.Injector) (Services, error) {
		baseService, err := do.Invoke[base.Service](i)
		if err != nil {
			return nil, err
		}
		fileService, err := do.Invoke[file.Service](i)
		if err != nil {
			return nil, err
		}
		return Services{baseService, fileService}, nil
	})
}
