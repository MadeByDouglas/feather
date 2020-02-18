//
//  FroalaSource.swift
//  Feather
//
//  Created by Douglas Hewitt on 2/14/20.
//  Copyright © 2020 Douglas Hewitt. All rights reserved.
//

import Foundation

let froalaView = """

<div class="fr-view", id="viewer">
</div>

<link href="froala_style.min.css" rel="stylesheet" type="text/css" />

<style>
    .fr-view {
        font-family:    Helvetica, sans-serif;
    }
</style>


"""

func froalaInit(key: String) -> String {
    
    return """

    <link href="froala_editor.pkgd.min.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="froala_editor.pkgd.min.js"></script>

    <div id="editor" ></div>

    <script>
        var editor = new FroalaEditor('#editor', {
                                        key: '\(key)',
                                        attribution: false,
                                        charCounterCount: false,
                                        placeholderText: '',
                                        quickInsertEnabled: false,
                                      
                                      events: {
                                        'commands.after': function (cmd, param1, param2) {
                                            // console.log(cmd);
                                            // console.log(param1);
                                            // console.log(param2);
                                            
                                            if(cmd == 'linkOpen') {
                                                window.webkit.messageHandlers.linkOpen.postMessage(this.selection.element().href);
                                            }

                                        },

                                        'url.linked': function (link) {
                                          // Do something here.
                                          // this is the editor instance.
                                          // console.log(link);
                                        },

                                        'image.inserted': function ($img, response) {
                                          // Do something here.
                                          // this is the editor instance.
                                          console.log($img);
                                          console.log(this);
                                        }
                                      }


                                      },
                                      function () {
                                        // editor.toolbar.hide();
                                      })


    </script>


    <style>
        .fr-box {
          display: flex;
          height: 100%;
          flex-direction: column;
        }

        .fr-wrapper {
            flex: 1;
        }

        .fr-element {
            min-height: 100%;
        }
    </style>




    """

    
}

