package fs

import (
	"fmt"

	"github.com/david88558855/arctic-fox-disk/server/internal/platform/runner"
)

type RemoveTask struct {
	Path string `json:"path"`
}

func (opt *RemoveTask) String() string {
	return fmt.Sprintf("删除 [%s]", opt.Path)
}

func (opt *RemoveTask) Execute(task runner.Task, fs FS) error {
	return fs.Remove(task.Context(), opt.Path)
}
