package service

import (
	"context"

	"github.com/david88558855/arctic-fox-disk/server/internal/api/file/types"
)

func (srv *serviceImpl) getFileSetting(ctx context.Context) *types.FileSetting {
	setting := new(types.FileSetting)
	_ = srv.settings.LoadSetting(ctx, "app.file", setting)
	return setting
}
