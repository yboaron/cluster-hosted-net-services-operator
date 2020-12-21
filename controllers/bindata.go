// Code generated for package controllers by go-bindata DO NOT EDIT. (@generated)
// sources:
// ../manifests/0000_81_cluster-hosted-net-services-operator_06_clusteroperator.cr.yaml
package controllers

import (
	"bytes"
	"compress/gzip"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
	"time"
)

func bindataRead(data []byte, name string) ([]byte, error) {
	gz, err := gzip.NewReader(bytes.NewBuffer(data))
	if err != nil {
		return nil, fmt.Errorf("Read %q: %v", name, err)
	}

	var buf bytes.Buffer
	_, err = io.Copy(&buf, gz)
	clErr := gz.Close()

	if err != nil {
		return nil, fmt.Errorf("Read %q: %v", name, err)
	}
	if clErr != nil {
		return nil, err
	}

	return buf.Bytes(), nil
}

type asset struct {
	bytes []byte
	info  os.FileInfo
}

type bindataFileInfo struct {
	name    string
	size    int64
	mode    os.FileMode
	modTime time.Time
}

// Name return file name
func (fi bindataFileInfo) Name() string {
	return fi.name
}

// Size return file size
func (fi bindataFileInfo) Size() int64 {
	return fi.size
}

// Mode return file mode
func (fi bindataFileInfo) Mode() os.FileMode {
	return fi.mode
}

// Mode return file modify time
func (fi bindataFileInfo) ModTime() time.Time {
	return fi.modTime
}

// IsDir return file whether a directory
func (fi bindataFileInfo) IsDir() bool {
	return fi.mode&os.ModeDir != 0
}

// Sys return file is sys mode
func (fi bindataFileInfo) Sys() interface{} {
	return nil
}

var _Manifests0000_81_clusterHostedNetServicesOperator_06_clusteroperatorCrYaml = []byte("\x1f\x8b\x08\x00\x00\x00\x00\x00\x00\xff\x54\x8f\xb1\x4e\x03\x31\x0c\x40\xf7\x7c\x85\x75\x7b\x8e\x76\xcd\xca\x07\xb0\xb1\x9b\xc4\x77\xb1\xc8\xd9\x51\xec\x8b\x84\x10\xff\x8e\xda\xd2\x81\xcd\x83\xed\xf7\x1e\x76\x7e\xa7\x61\xac\x92\x20\xab\x6c\xbc\xaf\xda\x49\xac\xf2\xe6\x2b\xeb\xcb\xbc\x86\x4f\x96\x92\xe0\xb5\x9d\xe6\x34\xde\x3a\x0d\x74\x1d\xe1\x20\xc7\x82\x8e\x29\x00\x08\x1e\x94\x20\x3f\x36\x62\x55\x73\x2a\x51\xc8\xa3\xd1\x98\x9c\xc9\x02\x00\x8a\xa8\xa3\xb3\x8a\xdd\x4e\x00\x58\x72\x3b\x0b\xad\x83\x1a\xa1\xd1\x7f\xac\x51\xdb\xe2\x81\x82\x3b\x95\x58\x79\xaf\x11\x27\x72\xc3\x0f\x6e\xec\x5f\x09\x16\x1f\x27\x2d\xc1\x3a\xe5\x04\xdf\x3f\xc1\x1c\xfd\xbc\x3f\x9e\x8f\x9a\xfb\x1c\xff\xcc\xf4\x29\x7d\xe3\xce\x67\xee\x72\x59\x2f\xeb\x35\x9a\x60\xb7\xaa\xbe\x84\xdf\x00\x00\x00\xff\xff\x61\x51\x03\x38\x0c\x01\x00\x00")

func Manifests0000_81_clusterHostedNetServicesOperator_06_clusteroperatorCrYamlBytes() ([]byte, error) {
	return bindataRead(
		_Manifests0000_81_clusterHostedNetServicesOperator_06_clusteroperatorCrYaml,
		"../manifests/0000_81_cluster-hosted-net-services-operator_06_clusteroperator.cr.yaml",
	)
}

func Manifests0000_81_clusterHostedNetServicesOperator_06_clusteroperatorCrYaml() (*asset, error) {
	bytes, err := Manifests0000_81_clusterHostedNetServicesOperator_06_clusteroperatorCrYamlBytes()
	if err != nil {
		return nil, err
	}

	info := bindataFileInfo{name: "../manifests/0000_81_cluster-hosted-net-services-operator_06_clusteroperator.cr.yaml", size: 0, mode: os.FileMode(0), modTime: time.Unix(0, 0)}
	a := &asset{bytes: bytes, info: info}
	return a, nil
}

// Asset loads and returns the asset for the given name.
// It returns an error if the asset could not be found or
// could not be loaded.
func Asset(name string) ([]byte, error) {
	cannonicalName := strings.Replace(name, "\\", "/", -1)
	if f, ok := _bindata[cannonicalName]; ok {
		a, err := f()
		if err != nil {
			return nil, fmt.Errorf("Asset %s can't read by error: %v", name, err)
		}
		return a.bytes, nil
	}
	return nil, fmt.Errorf("Asset %s not found", name)
}

// MustAsset is like Asset but panics when Asset would return an error.
// It simplifies safe initialization of global variables.
func MustAsset(name string) []byte {
	a, err := Asset(name)
	if err != nil {
		panic("asset: Asset(" + name + "): " + err.Error())
	}

	return a
}

// AssetInfo loads and returns the asset info for the given name.
// It returns an error if the asset could not be found or
// could not be loaded.
func AssetInfo(name string) (os.FileInfo, error) {
	cannonicalName := strings.Replace(name, "\\", "/", -1)
	if f, ok := _bindata[cannonicalName]; ok {
		a, err := f()
		if err != nil {
			return nil, fmt.Errorf("AssetInfo %s can't read by error: %v", name, err)
		}
		return a.info, nil
	}
	return nil, fmt.Errorf("AssetInfo %s not found", name)
}

// AssetNames returns the names of the assets.
func AssetNames() []string {
	names := make([]string, 0, len(_bindata))
	for name := range _bindata {
		names = append(names, name)
	}
	return names
}

// _bindata is a table, holding each asset generator, mapped to its name.
var _bindata = map[string]func() (*asset, error){
	"../manifests/0000_81_cluster-hosted-net-services-operator_06_clusteroperator.cr.yaml": Manifests0000_81_clusterHostedNetServicesOperator_06_clusteroperatorCrYaml,
}

// AssetDir returns the file names below a certain
// directory embedded in the file by go-bindata.
// For example if you run go-bindata on data/... and data contains the
// following hierarchy:
//     data/
//       foo.txt
//       img/
//         a.png
//         b.png
// then AssetDir("data") would return []string{"foo.txt", "img"}
// AssetDir("data/img") would return []string{"a.png", "b.png"}
// AssetDir("foo.txt") and AssetDir("notexist") would return an error
// AssetDir("") will return []string{"data"}.
func AssetDir(name string) ([]string, error) {
	node := _bintree
	if len(name) != 0 {
		cannonicalName := strings.Replace(name, "\\", "/", -1)
		pathList := strings.Split(cannonicalName, "/")
		for _, p := range pathList {
			node = node.Children[p]
			if node == nil {
				return nil, fmt.Errorf("Asset %s not found", name)
			}
		}
	}
	if node.Func != nil {
		return nil, fmt.Errorf("Asset %s not found", name)
	}
	rv := make([]string, 0, len(node.Children))
	for childName := range node.Children {
		rv = append(rv, childName)
	}
	return rv, nil
}

type bintree struct {
	Func     func() (*asset, error)
	Children map[string]*bintree
}

var _bintree = &bintree{nil, map[string]*bintree{
	"..": {nil, map[string]*bintree{
		"manifests": {nil, map[string]*bintree{
			"0000_81_cluster-hosted-net-services-operator_06_clusteroperator.cr.yaml": {Manifests0000_81_clusterHostedNetServicesOperator_06_clusteroperatorCrYaml, map[string]*bintree{}},
		}},
	}},
}}

// RestoreAsset restores an asset under the given directory
func RestoreAsset(dir, name string) error {
	data, err := Asset(name)
	if err != nil {
		return err
	}
	info, err := AssetInfo(name)
	if err != nil {
		return err
	}
	err = os.MkdirAll(_filePath(dir, filepath.Dir(name)), os.FileMode(0755))
	if err != nil {
		return err
	}
	err = ioutil.WriteFile(_filePath(dir, name), data, info.Mode())
	if err != nil {
		return err
	}
	err = os.Chtimes(_filePath(dir, name), info.ModTime(), info.ModTime())
	if err != nil {
		return err
	}
	return nil
}

// RestoreAssets restores an asset under the given directory recursively
func RestoreAssets(dir, name string) error {
	children, err := AssetDir(name)
	// File
	if err != nil {
		return RestoreAsset(dir, name)
	}
	// Dir
	for _, child := range children {
		err = RestoreAssets(dir, filepath.Join(name, child))
		if err != nil {
			return err
		}
	}
	return nil
}

func _filePath(dir, name string) string {
	cannonicalName := strings.Replace(name, "\\", "/", -1)
	return filepath.Join(append([]string{dir}, strings.Split(cannonicalName, "/")...)...)
}
