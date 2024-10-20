{
  "annotations": {
    "list": [
      {
        "$$hashKey": "object:2875",
        "builtIn": 1,
        "datasource": "-- Grafana --",
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "description": "Update 2020.10.10, add the overall resource overview! Support Grafana6&7,Support Node Exporter v0.16 and above.Optimize the main metrics display. Includes: CPU, memory, disk IO, network, temperature and other monitoring metrics。https://github.com/starsliao/Prometheus",
  "editable": true,
  "gnetId": 11074,
  "graphTooltip": 0,
  "id": 6,
  "iteration": 1729466142361,
  "links": [
    {
      "$$hashKey": "object:2302",
      "asDropdown": true,
      "icon": "external link",
      "tags": [],
      "targetBlank": true,
      "title": "",
      "type": "dashboards"
    },
    {
      "asDropdown": false,
      "icon": "external link",
      "includeVars": false,
      "keepTime": false,
      "tags": [],
      "targetBlank": true,
      "title": "Unity Grafana Dashboard",
      "tooltip": "",
      "type": "dashboards",
      "url": ""
    }
  ],
  "panels": [
    {
      "datasource": null,
      "gridPos": {
        "h": 6,
        "w": 24,
        "x": 0,
        "y": 0
      },
      "id": 191,
      "options": {
        "content": "<a href=\"https://ibb.co/68S9G3D\">\r\n    <img src=\"https://i.ibb.co/W0X87bB/UNITYGrafana-Story.png\" alt=\"UNITYGrafana-Story\" border=\"0\" \r\n         style=\"display: flex; justify-content: center; align-items: center; height: 100%; margin: auto;\">\r\n</a>\r\n",
        "mode": "markdown"
      },
      "pluginVersion": "8.0.6",
      "type": "text"
    },
    {
      "collapsed": false,
      "datasource": "Prometheus",
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 6
      },
      "id": 187,
      "panels": [],
      "title": "Service: $show_hostname",
      "type": "row"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "decimals": 1,
          "mappings": [
            {
              "options": {
                "0": {
                  "text": "N/A"
                }
              },
              "type": "value"
            }
          ],
          "max": 100,
          "min": 0.1,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "dark-green",
                "value": null
              },
              {
                "color": "semi-dark-orange",
                "value": 70
              },
              {
                "color": "semi-dark-red",
                "value": 90
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 6,
        "x": 0,
        "y": 7
      },
      "id": 177,
      "options": {
        "displayMode": "lcd",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "last"
          ],
          "fields": "",
          "values": false
        },
        "showUnfilled": true,
        "text": {}
      },
      "pluginVersion": "8.0.6",
      "targets": [
        {
          "exemplar": true,
          "expr": "100 - (avg(rate(node_cpu_seconds_total{instance=~\"$node\",mode=\"idle\"}[$interval])) * 100)",
          "instant": true,
          "interval": "",
          "legendFormat": "CPU used",
          "refId": "A"
        },
        {
          "expr": "avg(rate(node_cpu_seconds_total{instance=~\"$node\",mode=\"iowait\"}[$interval])) * 100",
          "hide": true,
          "instant": true,
          "interval": "",
          "legendFormat": "IOwait使用率",
          "refId": "C"
        },
        {
          "exemplar": true,
          "expr": "(1 - (node_memory_MemAvailable_bytes{instance=~\"$node\"} / (node_memory_MemTotal_bytes{instance=~\"$node\"})))* 100",
          "instant": true,
          "interval": "",
          "legendFormat": "RAM used",
          "refId": "B"
        },
        {
          "exemplar": true,
          "expr": "(node_filesystem_size_bytes{instance=~'$node',fstype=~\"ext.*|xfs\",mountpoint=\"$maxmount\"}-node_filesystem_free_bytes{instance=~'$node',fstype=~\"ext.*|xfs\",mountpoint=\"$maxmount\"})*100 /(node_filesystem_avail_bytes {instance=~'$node',fstype=~\"ext.*|xfs\",mountpoint=\"$maxmount\"}+(node_filesystem_size_bytes{instance=~'$node',fstype=~\"ext.*|xfs\",mountpoint=\"$maxmount\"}-node_filesystem_free_bytes{instance=~'$node',fstype=~\"ext.*|xfs\",mountpoint=\"$maxmount\"}))",
          "hide": false,
          "instant": true,
          "interval": "",
          "legendFormat": "Partition used",
          "refId": "D"
        },
        {
          "exemplar": true,
          "expr": "(1 - ((node_memory_SwapFree_bytes{instance=~\"$node\"} + 1)/ (node_memory_SwapTotal_bytes{instance=~\"$node\"} + 1))) * 100",
          "instant": true,
          "interval": "",
          "legendFormat": "SWAP used",
          "refId": "F"
        }
      ],
      "timeFrom": null,
      "timeShift": null,
      "transformations": [],
      "type": "bargauge"
    },
    {
      "datasource": "Prometheus",
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 20,
            "gradientMode": "opacity",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "light-purple",
                "value": null
              },
              {
                "color": "semi-dark-purple",
                "value": 80
              }
            ]
          }
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "Total"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "semi-dark-green",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "User"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "semi-dark-orange",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "System"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "super-light-green",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Iowait"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "light-orange",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 6,
        "w": 3,
        "x": 6,
        "y": 7
      },
      "id": 7,
      "links": [],
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom"
        },
        "tooltip": {
          "mode": "single"
        }
      },
      "pluginVersion": "8.0.6",
      "repeat": null,
      "targets": [
        {
          "exemplar": true,
          "expr": "avg(rate(node_cpu_seconds_total{instance=~\"$node\",mode=\"system\"}[$interval])) by (instance) *100",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "System",
          "refId": "A",
          "step": 20
        },
        {
          "expr": "avg(rate(node_cpu_seconds_total{instance=~\"$node\",mode=\"user\"}[$interval])) by (instance) *100",
          "format": "time_series",
          "hide": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "User",
          "refId": "B",
          "step": 240
        },
        {
          "expr": "avg(rate(node_cpu_seconds_total{instance=~\"$node\",mode=\"iowait\"}[$interval])) by (instance) *100",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "Iowait",
          "refId": "D",
          "step": 240
        },
        {
          "expr": "(1 - avg(rate(node_cpu_seconds_total{instance=~\"$node\",mode=\"idle\"}[$interval])) by (instance))*100",
          "format": "time_series",
          "hide": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "Total",
          "refId": "F",
          "step": 240
        }
      ],
      "timeFrom": null,
      "timeShift": null,
      "title": "CPU used",
      "type": "timeseries"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 20,
            "gradientMode": "opacity",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineStyle": {
              "fill": "solid"
            },
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "links": [],
          "mappings": [],
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "192.168.200.241:9100_总内存"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "dark-red",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "使用率"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "yellow",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "内存_Avaliable"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#6ED0E0",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "内存_Cached"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#EF843C",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "内存_Free"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#629E51",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "内存_Total"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#6d1f62",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "内存_Used"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#eab839",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "可用"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#9ac48a",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "总内存"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#bf1b00",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Total"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "semi-dark-green",
                  "mode": "fixed"
                }
              },
              {
                "id": "custom.fillOpacity",
                "value": 10
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Used%"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "rgb(0, 209, 255)",
                  "mode": "fixed"
                }
              },
              {
                "id": "custom.lineWidth",
                "value": 2
              },
              {
                "id": "custom.pointSize",
                "value": 1
              },
              {
                "id": "custom.showPoints",
                "value": "always"
              },
              {
                "id": "unit",
                "value": "percent"
              },
              {
                "id": "max",
                "value": 100
              },
              {
                "id": "custom.axisLabel",
                "value": "Utilization%"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Used"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "semi-dark-orange",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Avaliable"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "light-green",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 6,
        "w": 3,
        "x": 9,
        "y": 7
      },
      "id": 156,
      "links": [],
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom"
        },
        "tooltip": {
          "mode": "single"
        }
      },
      "pluginVersion": "8.0.6",
      "targets": [
        {
          "expr": "node_memory_MemTotal_bytes{instance=~\"$node\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "Total",
          "refId": "A",
          "step": 4
        },
        {
          "expr": "node_memory_MemTotal_bytes{instance=~\"$node\"} - node_memory_MemAvailable_bytes{instance=~\"$node\"}",
          "format": "time_series",
          "hide": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "Used",
          "refId": "B",
          "step": 4
        },
        {
          "expr": "node_memory_MemAvailable_bytes{instance=~\"$node\"}",
          "format": "time_series",
          "hide": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "Avaliable",
          "refId": "F",
          "step": 4
        },
        {
          "expr": "node_memory_Buffers_bytes{instance=~\"$node\"}",
          "format": "time_series",
          "hide": true,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "内存_Buffers",
          "refId": "D",
          "step": 4
        },
        {
          "expr": "node_memory_MemFree_bytes{instance=~\"$node\"}",
          "format": "time_series",
          "hide": true,
          "intervalFactor": 1,
          "legendFormat": "内存_Free",
          "refId": "C",
          "step": 4
        },
        {
          "expr": "node_memory_Cached_bytes{instance=~\"$node\"}",
          "format": "time_series",
          "hide": true,
          "intervalFactor": 1,
          "legendFormat": "内存_Cached",
          "refId": "E",
          "step": 4
        },
        {
          "expr": "node_memory_MemTotal_bytes{instance=~\"$node\"} - (node_memory_Cached_bytes{instance=~\"$node\"} + node_memory_Buffers_bytes{instance=~\"$node\"} + node_memory_MemFree_bytes{instance=~\"$node\"})",
          "format": "time_series",
          "hide": true,
          "intervalFactor": 1,
          "refId": "G"
        },
        {
          "exemplar": true,
          "expr": "(1 - (node_memory_MemAvailable_bytes{instance=~\"$node\"} / (node_memory_MemTotal_bytes{instance=~\"$node\"})))* 100",
          "format": "time_series",
          "hide": true,
          "interval": "30m",
          "intervalFactor": 10,
          "legendFormat": "Used%",
          "refId": "H"
        }
      ],
      "timeFrom": null,
      "timeShift": null,
      "title": "RAM used",
      "type": "timeseries"
    },
    {
      "datasource": "Prometheus",
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 20,
            "gradientMode": "opacity",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "links": [],
          "mappings": [],
          "max": 100,
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/Inodes.*/"
            },
            "properties": [
              {
                "id": "unit",
                "value": "percentunit"
              },
              {
                "id": "decimals",
                "value": 2
              },
              {
                "id": "max",
                "value": 1
              },
              {
                "id": "custom.axisPlacement",
                "value": "hidden"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "semi-dark-yellow",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 6,
        "w": 3,
        "x": 12,
        "y": 7
      },
      "id": 174,
      "links": [],
      "options": {
        "legend": {
          "calcs": [
            "mean",
            "lastNotNull",
            "max",
            "min"
          ],
          "displayMode": "hidden",
          "placement": "bottom"
        },
        "tooltip": {
          "mode": "single"
        }
      },
      "pluginVersion": "8.0.6",
      "targets": [
        {
          "expr": "(node_filesystem_size_bytes{instance=~'$node',fstype=~\"ext.*|xfs\",mountpoint !~\".*pod.*\"}-node_filesystem_free_bytes{instance=~'$node',fstype=~\"ext.*|xfs\",mountpoint !~\".*pod.*\"}) *100/(node_filesystem_avail_bytes {instance=~'$node',fstype=~\"ext.*|xfs\",mountpoint !~\".*pod.*\"}+(node_filesystem_size_bytes{instance=~'$node',fstype=~\"ext.*|xfs\",mountpoint !~\".*pod.*\"}-node_filesystem_free_bytes{instance=~'$node',fstype=~\"ext.*|xfs\",mountpoint !~\".*pod.*\"}))",
          "format": "time_series",
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "{{mountpoint}}",
          "refId": "A"
        },
        {
          "expr": "node_filesystem_files_free{instance=~'$node',fstype=~\"ext.?|xfs\"} / node_filesystem_files{instance=~'$node',fstype=~\"ext.?|xfs\"}",
          "hide": true,
          "interval": "",
          "legendFormat": "Inodes：{{instance}}：{{mountpoint}}",
          "refId": "B"
        }
      ],
      "timeFrom": null,
      "timeShift": null,
      "title": "Disk Space Used",
      "type": "timeseries"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisLabel": "transmit  /  receive",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 20,
            "gradientMode": "opacity",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "links": [],
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "bps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "192.168.10.227:9100_em1_in下载"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "super-light-green",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "192.168.10.227:9100_em1_out上传"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "dark-blue",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "ens3_transmit"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "light-blue",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "ens3_receive"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "light-purple",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "receive"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "dark-yellow",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "transmit"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "semi-dark-green",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 6,
        "w": 3,
        "x": 15,
        "y": 7
      },
      "id": 157,
      "links": [],
      "options": {
        "legend": {
          "calcs": [
            "mean",
            "lastNotNull",
            "max",
            "min"
          ],
          "displayMode": "hidden",
          "placement": "bottom"
        },
        "tooltip": {
          "mode": "single"
        }
      },
      "pluginVersion": "8.0.6",
      "targets": [
        {
          "exemplar": true,
          "expr": "rate(node_network_receive_bytes_total{instance=~'$node',device=~\"$device\"}[$interval])*8",
          "format": "time_series",
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "receive",
          "refId": "A",
          "step": 4
        },
        {
          "exemplar": true,
          "expr": "rate(node_network_transmit_bytes_total{instance=~'$node',device=~\"$device\"}[$interval])*8",
          "format": "time_series",
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "transmit",
          "refId": "B",
          "step": 4
        }
      ],
      "timeFrom": null,
      "timeShift": null,
      "title": "Network bandwidth per second",
      "type": "timeseries"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisLabel": "transmit  /  receive",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 20,
            "gradientMode": "opacity",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 4,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "links": [],
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "cn-shenzhen.i-wz9cq1dcb6zwc39ehw59_cni0_in"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "light-red",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "cn-shenzhen.i-wz9cq1dcb6zwc39ehw59_cni0_in下载"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "green",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "cn-shenzhen.i-wz9cq1dcb6zwc39ehw59_cni0_out上传"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "yellow",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "cn-shenzhen.i-wz9cq1dcb6zwc39ehw59_eth0_in下载"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "purple",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "cn-shenzhen.i-wz9cq1dcb6zwc39ehw59_eth0_out"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "purple",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "cn-shenzhen.i-wz9cq1dcb6zwc39ehw59_eth0_out上传"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "blue",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "ens3_receive"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "light-purple",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "ens3_transmit"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "light-blue",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "receive"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "semi-dark-green",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "transmit"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "semi-dark-yellow",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 6,
        "w": 3,
        "x": 18,
        "y": 7
      },
      "id": 183,
      "links": [],
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "hidden",
          "placement": "bottom"
        },
        "tooltip": {
          "mode": "single"
        }
      },
      "pluginVersion": "8.0.6",
      "repeat": null,
      "targets": [
        {
          "exemplar": true,
          "expr": "increase(node_network_receive_bytes_total{instance=~\"$node\",device=~\"$device\"}[60m])",
          "interval": "60m",
          "intervalFactor": 1,
          "legendFormat": "receive",
          "metric": "",
          "refId": "A",
          "step": 600,
          "target": ""
        },
        {
          "exemplar": true,
          "expr": "increase(node_network_transmit_bytes_total{instance=~\"$node\",device=~\"$device\"}[60m])",
          "hide": false,
          "interval": "60m",
          "intervalFactor": 1,
          "legendFormat": "transmit",
          "refId": "B",
          "step": 600
        }
      ],
      "timeFrom": null,
      "timeShift": null,
      "title": "Internet traffic per hour",
      "type": "timeseries"
    },
    {
      "cacheTimeout": null,
      "datasource": "Prometheus",
      "description": "",
      "fieldConfig": {
        "defaults": {
          "decimals": 0,
          "mappings": [
            {
              "options": {
                "match": "null",
                "result": {
                  "text": "N/A"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "dark-green",
                "value": null
              },
              {
                "color": "dark-green",
                "value": 1
              },
              {
                "color": "dark-green",
                "value": 3
              }
            ]
          },
          "unit": "s"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 3,
        "x": 21,
        "y": 7
      },
      "hideTimeOverride": true,
      "id": 15,
      "interval": null,
      "links": [],
      "maxDataPoints": 100,
      "options": {
        "colorMode": "value",
        "graphMode": "none",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "8.0.6",
      "targets": [
        {
          "expr": "avg(time() - node_boot_time_seconds{instance=~\"$node\"})",
          "format": "time_series",
          "hide": false,
          "instant": true,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "",
          "refId": "A",
          "step": 40
        }
      ],
      "title": "Uptime",
      "type": "stat"
    },
    {
      "collapsed": false,
      "datasource": "Prometheus",
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 13
      },
      "id": 189,
      "panels": [],
      "title": "Story metrics",
      "type": "row"
    },
    {
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 5,
        "x": 0,
        "y": 14
      },
      "id": 193,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "8.0.6",
      "targets": [
        {
          "exemplar": true,
          "expr": "cometbft_consensus_height{instance=\"localhost:33660\"}",
          "interval": "",
          "legendFormat": "",
          "refId": "A"
        }
      ],
      "title": "Block Height",
      "type": "stat"
    },
    {
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 4,
        "x": 5,
        "y": 14
      },
      "id": 195,
      "options": {
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showThresholdLabels": false,
        "showThresholdMarkers": true,
        "text": {}
      },
      "pluginVersion": "8.0.6",
      "targets": [
        {
          "exemplar": true,
          "expr": "cometbft_consensus_validators{instance=\"localhost:33660\"} - cometbft_consensus_missing_validators{instance=\"localhost:33660\"}\n",
          "interval": "",
          "legendFormat": "",
          "refId": "A"
        }
      ],
      "title": "Online Valiator info",
      "type": "gauge"
    },
    {
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 3,
        "x": 9,
        "y": 14
      },
      "id": 197,
      "options": {
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showThresholdLabels": false,
        "showThresholdMarkers": true,
        "text": {}
      },
      "pluginVersion": "8.0.6",
      "targets": [
        {
          "exemplar": true,
          "expr": "cometbft_p2p_peers{instance=\"localhost:33660\"}",
          "interval": "",
          "legendFormat": "",
          "refId": "A"
        }
      ],
      "title": "Peers",
      "type": "gauge"
    },
    {
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 4,
        "x": 12,
        "y": 14
      },
      "id": 199,
      "options": {
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showThresholdLabels": false,
        "showThresholdMarkers": true,
        "text": {}
      },
      "pluginVersion": "8.0.6",
      "targets": [
        {
          "exemplar": true,
          "expr": "cometbft_consensus_num_txs{instance=\"localhost:33660\"}",
          "interval": "",
          "legendFormat": "",
          "refId": "A"
        }
      ],
      "title": "TPS Chain",
      "type": "gauge"
    },
    {
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 4,
        "x": 16,
        "y": 14
      },
      "id": 201,
      "options": {
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showThresholdLabels": false,
        "showThresholdMarkers": true,
        "text": {}
      },
      "pluginVersion": "8.0.6",
      "targets": [
        {
          "exemplar": true,
          "expr": "rate(cometbft_consensus_block_interval_seconds_sum{instance=\"localhost:33660\"}[1m]) - rate(cometbft_consensus_block_interval_seconds_count{instance=\"localhost:33660\"}[1m])\n",
          "interval": "",
          "legendFormat": "",
          "refId": "A"
        }
      ],
      "title": "Avg Block Time",
      "type": "gauge"
    },
    {
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "KiBs"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 4,
        "x": 20,
        "y": 14
      },
      "id": 203,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "8.0.6",
      "targets": [
        {
          "exemplar": true,
          "expr": "cometbft_consensus_block_size_bytes{instance=\"localhost:33660\"}",
          "interval": "",
          "legendFormat": "",
          "refId": "A"
        }
      ],
      "title": "Block Size",
      "type": "stat"
    },
    {
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 7,
        "w": 9,
        "x": 0,
        "y": 20
      },
      "id": 205,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom"
        },
        "tooltip": {
          "mode": "single"
        }
      },
      "targets": [
        {
          "exemplar": true,
          "expr": "rate(cometbft_consensus_total_txs{instance=\"localhost:33660\"}[1m])\n",
          "interval": "",
          "legendFormat": "",
          "refId": "A"
        }
      ],
      "title": "Confirmed chain TXs",
      "type": "timeseries"
    },
    {
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 7,
        "w": 7,
        "x": 9,
        "y": 20
      },
      "id": 207,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "8.0.6",
      "targets": [
        {
          "exemplar": true,
          "expr": "cometbft_consensus_validators_power{instance=\"localhost:33660\", chain_id=\"$chain_id\"}",
          "interval": "",
          "legendFormat": "Validator Power",
          "refId": "A"
        },
        {
          "exemplar": true,
          "expr": "cometbft_consensus_missing_validators_power{instance=\"localhost:33660\", chain_id=\"$chain_id\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "Missing Validator Power",
          "refId": "B"
        }
      ],
      "title": "Validator Power",
      "type": "stat"
    },
    {
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 7,
        "w": 8,
        "x": 16,
        "y": 20
      },
      "id": 209,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "8.0.6",
      "targets": [
        {
          "exemplar": true,
          "expr": "cometbft_consensus_num_txs{chain_id=\"${chain_id}\", instance=\"localhost:33660\"}\n",
          "interval": "",
          "legendFormat": "",
          "refId": "A"
        }
      ],
      "title": "Transactions",
      "type": "stat"
    }
  ],
  "refresh": "",
  "schemaVersion": 30,
  "style": "dark",
  "tags": [],
  "templating": {
    "list": [
      {
        "allValue": "",
        "current": {
          "isNone": true,
          "selected": false,
          "text": "None",
          "value": ""
        },
        "datasource": "Prometheus",
        "definition": "label_values(origin_prometheus)",
        "description": null,
        "error": null,
        "hide": 2,
        "includeAll": false,
        "label": "Origin_prom",
        "multi": false,
        "name": "origin_prometheus",
        "options": [],
        "query": {
          "query": "label_values(origin_prometheus)",
          "refId": "Prometheus-origin_prometheus-Variable-Query"
        },
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 5,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "allValue": null,
        "current": {
          "selected": false,
          "text": "node_exporter",
          "value": "node_exporter"
        },
        "datasource": "Prometheus",
        "definition": "label_values(node_uname_info{origin_prometheus=~\"$origin_prometheus\"}, job)",
        "description": null,
        "error": null,
        "hide": 2,
        "includeAll": false,
        "label": "JOB",
        "multi": false,
        "name": "job",
        "options": [],
        "query": {
          "query": "label_values(node_uname_info{origin_prometheus=~\"$origin_prometheus\"}, job)",
          "refId": "Prometheus-job-Variable-Query"
        },
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 5,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "allValue": null,
        "current": {
          "selected": false,
          "text": "Contabo-Test",
          "value": "Contabo-Test"
        },
        "datasource": "Prometheus",
        "definition": "label_values(node_uname_info{origin_prometheus=~\"$origin_prometheus\",job=~\"$job\"}, label)",
        "description": null,
        "error": null,
        "hide": 0,
        "includeAll": false,
        "label": "Node",
        "multi": false,
        "name": "hostname",
        "options": [],
        "query": {
          "query": "label_values(node_uname_info{origin_prometheus=~\"$origin_prometheus\",job=~\"$job\"}, label)",
          "refId": "StandardVariableQuery"
        },
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 5,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "allFormat": "glob",
        "allValue": null,
        "current": {
          "selected": false,
          "text": "213.136.91.146:9100",
          "value": "213.136.91.146:9100"
        },
        "datasource": "Prometheus",
        "definition": "label_values(node_uname_info{origin_prometheus=~\"$origin_prometheus\",job=~\"$job\",label=~\"$hostname\"},instance)",
        "description": null,
        "error": null,
        "hide": 2,
        "includeAll": false,
        "label": "Instance",
        "multi": true,
        "multiFormat": "regex values",
        "name": "node",
        "options": [],
        "query": {
          "query": "label_values(node_uname_info{origin_prometheus=~\"$origin_prometheus\",job=~\"$job\",label=~\"$hostname\"},instance)",
          "refId": "StandardVariableQuery"
        },
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 5,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "allFormat": "glob",
        "allValue": null,
        "current": {
          "selected": true,
          "text": [
            "All"
          ],
          "value": [
            "$__all"
          ]
        },
        "datasource": "Prometheus",
        "definition": "label_values(node_network_info{origin_prometheus=~\"$origin_prometheus\",device!~'tap.*|veth.*|br.*|docker.*|virbr.*|lo.*|cni.*'},device)",
        "description": null,
        "error": null,
        "hide": 2,
        "includeAll": true,
        "label": "NIC",
        "multi": true,
        "multiFormat": "regex values",
        "name": "device",
        "options": [],
        "query": {
          "query": "label_values(node_network_info{origin_prometheus=~\"$origin_prometheus\",device!~'tap.*|veth.*|br.*|docker.*|virbr.*|lo.*|cni.*'},device)",
          "refId": "Prometheus-device-Variable-Query"
        },
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 1,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "auto": false,
        "auto_count": 100,
        "auto_min": "10s",
        "current": {
          "selected": false,
          "text": "30m",
          "value": "30m"
        },
        "description": null,
        "error": null,
        "hide": 0,
        "label": "Interval",
        "name": "interval",
        "options": [
          {
            "selected": false,
            "text": "30s",
            "value": "30s"
          },
          {
            "selected": false,
            "text": "1m",
            "value": "1m"
          },
          {
            "selected": false,
            "text": "2m",
            "value": "2m"
          },
          {
            "selected": false,
            "text": "3m",
            "value": "3m"
          },
          {
            "selected": false,
            "text": "5m",
            "value": "5m"
          },
          {
            "selected": false,
            "text": "10m",
            "value": "10m"
          },
          {
            "selected": true,
            "text": "30m",
            "value": "30m"
          }
        ],
        "query": "30s,1m,2m,3m,5m,10m,30m",
        "queryValue": "",
        "refresh": 2,
        "skipUrlSync": false,
        "type": "interval"
      },
      {
        "allValue": null,
        "current": {
          "selected": false,
          "text": "/",
          "value": "/"
        },
        "datasource": "Prometheus",
        "definition": "query_result(topk(1,sort_desc (max(node_filesystem_size_bytes{origin_prometheus=~\"$origin_prometheus\",instance=~'$node',fstype=~\"ext.?|xfs\",mountpoint!~\".*pods.*\"}) by (mountpoint))))",
        "description": null,
        "error": null,
        "hide": 2,
        "includeAll": false,
        "label": "maxmount",
        "multi": false,
        "name": "maxmount",
        "options": [],
        "query": {
          "query": "query_result(topk(1,sort_desc (max(node_filesystem_size_bytes{origin_prometheus=~\"$origin_prometheus\",instance=~'$node',fstype=~\"ext.?|xfs\",mountpoint!~\".*pods.*\"}) by (mountpoint))))",
          "refId": "Prometheus-maxmount-Variable-Query"
        },
        "refresh": 2,
        "regex": "/.*\\\"(.*)\\\".*/",
        "skipUrlSync": false,
        "sort": 5,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "allValue": null,
        "current": {
          "selected": false,
          "text": "Contabo-Test",
          "value": "Contabo-Test"
        },
        "datasource": "Prometheus",
        "definition": "label_values(node_uname_info{origin_prometheus=~\"$origin_prometheus\",job=~\"$job\",instance=~\"$node\"}, label)",
        "description": null,
        "error": null,
        "hide": 2,
        "includeAll": false,
        "label": "show_hostname",
        "multi": false,
        "name": "show_hostname",
        "options": [],
        "query": {
          "query": "label_values(node_uname_info{origin_prometheus=~\"$origin_prometheus\",job=~\"$job\",instance=~\"$node\"}, label)",
          "refId": "StandardVariableQuery"
        },
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 5,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "allValue": null,
        "current": {
          "selected": false,
          "text": "2",
          "value": "2"
        },
        "datasource": "Prometheus",
        "definition": "query_result(count(node_uname_info{origin_prometheus=~\"$origin_prometheus\",job=~\"$job\"}))",
        "description": null,
        "error": null,
        "hide": 2,
        "includeAll": false,
        "label": "total_servers",
        "multi": false,
        "name": "total",
        "options": [],
        "query": {
          "query": "query_result(count(node_uname_info{origin_prometheus=~\"$origin_prometheus\",job=~\"$job\"}))",
          "refId": "Prometheus-total-Variable-Query"
        },
        "refresh": 1,
        "regex": "/{} (.*) .*/",
        "skipUrlSync": false,
        "sort": 0,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "allValue": null,
        "current": {
          "selected": false,
          "text": "iliad-0",
          "value": "iliad-0"
        },
        "datasource": null,
        "definition": "label_values(cometbft_consensus_height, chain_id)",
        "description": "",
        "error": null,
        "hide": 0,
        "includeAll": false,
        "label": null,
        "multi": false,
        "name": "chain_id",
        "options": [],
        "query": {
          "query": "label_values(cometbft_consensus_height, chain_id)",
          "refId": "StandardVariableQuery"
        },
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 0,
        "type": "query"
      }
    ]
  },
  "time": {
    "from": "now-6h",
    "to": "now"
  },
  "timepicker": {
    "hidden": false,
    "now": true,
    "refresh_intervals": [
      "15s",
      "30s",
      "1m",
      "5m",
      "15m",
      "30m"
    ],
    "time_options": [
      "5m",
      "15m",
      "1h",
      "6h",
      "12h",
      "24h",
      "2d",
      "7d",
      "30d"
    ]
  },
  "timezone": "browser",
  "title": "Story",
  "uid": "storyprotocol",
  "version": 16
}
