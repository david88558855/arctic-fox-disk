package types

import (
	"github.com/david88558855/arctic-fox-disk/server/internal/app"
	"github.com/david88558855/arctic-fox-disk/server/internal/platform/runner"
)

type Context struct {
	*app.Context
	Runner runner.Runner
}

func NewContext(ctx *app.Context, runner runner.Runner) *Context {
	return &Context{Context: ctx, Runner: runner}
}
