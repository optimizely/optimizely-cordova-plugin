package com.optimizely.cordova;

import org.apache.cordova.*;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;

import com.optimizely.Optimizely;
import com.optimizely.CodeBlocks.CodeBranch;
import com.optimizely.CodeBlocks.DefaultCodeBranch;
import com.optimizely.CodeBlocks.OptimizelyCodeBlock;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Set;

public class OptimizelyCordovaPlugin extends CordovaPlugin {
    private static HashMap<String, OptimizelyCordovaLiveVariable> liveVariables;
    private static HashMap<String, OptimizelyCodeBlock> codeBlocks;

    @Override
    public boolean execute(String action, JSONArray data, final CallbackContext callbackContext) throws JSONException {

        if (action.equals("booleanVariable")) {
            registerVariable(data, OptimizelyCordovaLiveVariable.BOOLEAN, callbackContext);
            return true;
        } else if (action.equals("codeBlock")) {
            String codeBlockKey = data.getString(0);
            JSONArray codeBlockBranchNamesJSON = data.getJSONArray(1);
            ArrayList<String> codeBlockBranchNames = new ArrayList();
            for (int i = 0; i < codeBlockBranchNamesJSON.length(); i++) {
                String branchName = codeBlockBranchNamesJSON.get(i).toString();
                codeBlockBranchNames.add(branchName);
            }
            codeBlock(codeBlockKey, codeBlockBranchNames, callbackContext);
            return true;
        } else if (action.equals("colorVariable")) {
            registerVariable(data, OptimizelyCordovaLiveVariable.COLOR, callbackContext);
            return true;
        } else if (action.equals("enableEditor")) {
            enableEditor(callbackContext);
            return true;
        } else if (action.equals("executeCodeBlock")) {
            String codeBlockKey = data.getString(0);
            executeCodeBlock(codeBlockKey, callbackContext);
            return true;
        } else if (action.equals("numberVariable")) {
            registerVariable(data, OptimizelyCordovaLiveVariable.NUMBER, callbackContext);
            return true;
        } else if (action.equals("startOptimizely")) {
            String token = data.getString(0);
            startOptimizely(token, callbackContext);
            return true;
        } else if (action.equals("stringVariable")) {
            registerVariable(data, OptimizelyCordovaLiveVariable.STRING, callbackContext);
            return true;
        } else if (action.equals("trackEvent")) {
            String eventName = data.getString(0);
            return trackEvent(eventName, callbackContext);
        } else if (action.equals("trackRevenueWithDescription")) {
            int revenueAmount = data.getInt(0);
            String revenueDescription = data.getString(1);
            return trackRevenueWithDescription(revenueAmount, revenueDescription, callbackContext);
        } else if (action.equals("variableForKey")) {
            String variableKey = data.getString(0);
            variableForKey(variableKey, callbackContext);
            return true;
        }

        return false;
    }

    private boolean enableEditor(final CallbackContext callbackContext) {
      cordova.getActivity().runOnUiThread(new Runnable() {
        public void run() {
          try {
            Optimizely.enableEditor();
            // right now we do not support visual editing
            Optimizely.setVisualExperimentsEnabled(false);
            callbackContext.success("Editor Enabled");
          } catch (Exception e) {
            callbackContext.error(e.getMessage());
          }
        }
      });
      return true;
    }

    private boolean startOptimizely(final String socketToken, final CallbackContext callbackContext) {
      cordova.getActivity().runOnUiThread(new Runnable() {
        public void run() {
          Optimizely.startOptimizely(socketToken, cordova.getActivity().getApplication());
          callbackContext.success("Optimizely Started");
        }
      });
      return true;
    }

    private boolean registerVariable(final JSONArray variableData, final int variableType, final CallbackContext callbackContext) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    if (liveVariables == null) {
                        liveVariables = new HashMap<String, OptimizelyCordovaLiveVariable>();
                    }
                    String variableKey = variableData.getString(0);

                    OptimizelyCordovaLiveVariable liveVariable = OptimizelyCordovaLiveVariable.fromJSON(variableData, variableType);
                    liveVariables.put(variableKey, liveVariable);
                    callbackContext.success();
                } catch (Exception e) {
                    callbackContext.error("Unable to register live variable: " + e.getMessage());
                }
            }
        });

        return true;
    }

    private boolean variableForKey(final String variableKey, final CallbackContext callbackContext) {
      cordova.getActivity().runOnUiThread(new Runnable() {
        public void run() {
          if (liveVariables.containsKey(variableKey)) {
            OptimizelyCordovaLiveVariable liveVariable = liveVariables.get(variableKey);

            try {
              // construct the JSON object for the variable
              JSONObject variableValue = new JSONObject();
              variableValue.put("variableKey", variableKey);
              variableValue.put("variableValue", liveVariable.getValue());
              callbackContext.success(variableValue);
            } catch (JSONException ex) {
              callbackContext.error(ex.getMessage());
            }
          } else {
            callbackContext.error("Variable for key: " + variableKey + " does not exist.");
          }
        }
      });
      return true;
    }

    private boolean codeBlock(final String codeBlockKey, final ArrayList<String> branches, final CallbackContext callbackContext) {
      cordova.getActivity().runOnUiThread(new Runnable() {
        public void run() {
          if (codeBlocks == null) {
            codeBlocks = new HashMap();
          }
          codeBlocks.put(codeBlockKey, Optimizely.codeBlock(codeBlockKey)
            .withBranchNames(branches.toArray(new String[branches.size()])));
          callbackContext.success();
        }
      });
      return true;
    }

    private boolean executeCodeBlock(final String codeBlockKey, final CallbackContext callbackContext) {
      cordova.getActivity().runOnUiThread(new Runnable() {
        public void run() {
          if (codeBlocks.containsKey(codeBlockKey)) {
            OptimizelyCodeBlock codeBlock = codeBlocks.get(codeBlockKey);
            ArrayList<CodeBranch> codeBranches = new ArrayList();
            Set<String> branchNames = codeBlock.getBranchNames();
            for (int i = 1; i < branchNames.size(); i++) {
                final String branchIndex = String.valueOf(i);
                codeBranches.add(new CodeBranch() {
                    @Override
                    public void execute() {
                      callbackContext.success(branchIndex);
                    }
                });
            }

            CodeBranch[] codeBranchesArray = codeBranches.toArray(new CodeBranch[codeBranches.size()]);
            codeBlock.execute(new DefaultCodeBranch() {
              @Override
              public void execute() {
                callbackContext.success("0");
              }
            }, codeBranchesArray);
          } else {
            callbackContext.error("Codeblock for key: " + codeBlockKey + " does not exist.");
          }
        }
      });
      return true;
    }

    private boolean trackEvent(final String eventName, final CallbackContext callbackContext) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Optimizely.trackEvent(eventName);
                callbackContext.success();
            }
        });
        return true;
    }

    private boolean trackRevenueWithDescription(final int revenueAmount, final String revenueDescription, final CallbackContext callbackContext) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Optimizely.trackRevenueWithDescription(revenueAmount, revenueDescription);
                callbackContext.success();
            }
        });
        return true;
    }
}
